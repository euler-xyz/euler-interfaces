import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import * as viemChains from 'viem/chains';
import {
  CHAIN_STATUSES,
  explorerUrlProblem,
  statusProblem,
  validateChains,
  viemChainProblem,
} from './validate-chains.mjs';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));
const validatorPath = fileURLToPath(new URL('./validate-chains.mjs', import.meta.url));

const fakeChain = (id, name) => ({
  id,
  name,
  nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
  rpcUrls: { default: { http: [`https://rpc.${name}.example`] } },
});

const one = fakeChain(10, 'one');
const twinA = fakeChain(20, 'twinA');
const twinB = fakeChain(20, 'twinB');
const catalog = Object.freeze({
  one,
  oneAlias: one,
  twinA,
  twinB,
  notAChain: { id: 30 },
});

const row = (overrides = {}) => ({
  chainId: 10,
  name: 'one',
  explorerUrl: 'https://explorer.one.example',
  status: 'production',
  addresses: {},
  ...overrides,
});

describe('statusProblem', () => {
  it('accepts every registry status', () => {
    for (const status of CHAIN_STATUSES) {
      assert.equal(statusProblem(status), null, status);
    }
  });

  it('lists exactly the four statuses', () => {
    assert.deepEqual([...CHAIN_STATUSES], ['staging', 'production', 'unlisted', 'deprecated']);
  });

  it('rejects the retired status testing', () => {
    assert.match(statusProblem('testing'), /status "testing" is not one of staging, production, unlisted, deprecated/);
  });

  it('rejects a missing, misspelt or non-string status', () => {
    assert.match(statusProblem(undefined), /status is missing/);
    assert.match(statusProblem('Production'), /is not one of/);
    assert.match(statusProblem(1), /is not one of/);
  });
});

describe('explorerUrlProblem', () => {
  it('accepts an https origin', () => {
    assert.equal(explorerUrlProblem('https://etherscan.io'), null);
    assert.equal(explorerUrlProblem('https://explorer.tac.build'), null);
  });

  it('rejects a missing or non-string value', () => {
    assert.match(explorerUrlProblem(undefined), /explorerUrl is missing/);
    assert.match(explorerUrlProblem(''), /explorerUrl is missing/);
    assert.match(explorerUrlProblem(42), /explorerUrl is missing/);
  });

  it('rejects a value that is not a URL', () => {
    assert.match(explorerUrlProblem('etherscan.io'), /is not a URL/);
  });

  it('rejects a non-https scheme', () => {
    assert.match(explorerUrlProblem('http://etherscan.io'), /must use https/);
  });

  it('rejects a trailing slash', () => {
    assert.match(explorerUrlProblem('https://etherscan.io/'), /must not end with a slash/);
  });

  it('rejects a path, query, fragment, credentials or a non-canonical host', () => {
    for (const value of [
      'https://etherscan.io/mainnet',
      'https://etherscan.io?x=1',
      'https://etherscan.io#top',
      'https://user:pass@etherscan.io',
      'https://Etherscan.io',
      'https://etherscan.io:443',
    ]) {
      assert.match(explorerUrlProblem(value), /must be an https origin/, value);
    }
  });
});

describe('viemChainProblem', () => {
  it('accepts a viemName that names a viem chain with the chain id', () => {
    assert.equal(viemChainProblem({ chainId: 20, viemName: 'twinA' }, catalog), null);
  });

  it('rejects a viemName that viem does not export', () => {
    assert.match(
      viemChainProblem({ chainId: 20, viemName: 'missing' }, catalog),
      /viemName "missing" is not a viem chain with id 20/,
    );
  });

  it('rejects a viemName whose viem chain has another id', () => {
    assert.match(viemChainProblem({ chainId: 20, viemName: 'one' }, catalog), /is not a viem chain with id 20/);
  });

  it('rejects a viemName that names an export that is not a chain', () => {
    assert.match(viemChainProblem({ chainId: 30, viemName: 'notAChain' }, catalog), /is not a viem chain with id 30/);
  });

  it('accepts a chain without viemName when viem has exactly one chain with its id', () => {
    assert.equal(viemChainProblem({ chainId: 10 }, catalog), null);
  });

  it('rejects a chain without viemName when viem has several chains with its id', () => {
    assert.match(
      viemChainProblem({ chainId: 20 }, catalog),
      /viem has several chains with id 20 \(twinA, twinB\); set viemName/,
    );
  });

  it('rejects a chain without viemName when viem has no chain with its id', () => {
    assert.match(viemChainProblem({ chainId: 99 }, catalog), /viem has no chain with id 99/);
  });

  it('rejects a viemName that is not a non-empty string', () => {
    assert.match(viemChainProblem({ chainId: 10, viemName: '' }, catalog), /viemName must be a non-empty string/);
  });

  it('resolves the duplicate ids in the pinned viem only through viemName', () => {
    assert.match(viemChainProblem({ chainId: 8453 }, viemChains), /viem has several chains with id 8453/);
    assert.match(viemChainProblem({ chainId: 999 }, viemChains), /viem has several chains with id 999/);
    assert.equal(viemChainProblem({ chainId: 8453, viemName: 'base' }, viemChains), null);
    assert.equal(viemChainProblem({ chainId: 999, viemName: 'hyperEvm' }, viemChains), null);
  });
});

describe('validateChains', () => {
  it('returns no problems for valid rows', () => {
    assert.deepEqual(validateChains([row(), row({ chainId: 20, name: 'two', viemName: 'twinB' })], catalog), []);
  });

  it('prefixes each problem with the chain it belongs to', () => {
    const problems = validateChains(
      [row({ chainId: 20, name: 'two', status: 'testing', explorerUrl: 'https://two.example/' })],
      catalog,
    );
    assert.equal(problems.length, 3);
    for (const problem of problems) assert.match(problem, /^chain 20 \(two\): /);
  });

  it('rejects a payload that is not a list', () => {
    assert.deepEqual(validateChains({}, catalog), ['EulerChains.json must be a list of chains']);
  });

  it('rejects a row without an integer chain id', () => {
    assert.deepEqual(validateChains([row({ chainId: '10' })], catalog), ['row 0: chainId must be a positive integer']);
    assert.deepEqual(validateChains([null], catalog), ['row 0: chainId must be a positive integer']);
  });

  it('passes the committed EulerChains.json against the pinned viem', () => {
    const chains = JSON.parse(readFileSync(join(repoRoot, 'EulerChains.json'), 'utf8'));
    assert.deepEqual(validateChains(chains, viemChains), []);
  });
});

describe('command line', () => {
  const run = (payload) => {
    const dir = mkdtempSync(join(tmpdir(), 'validate-chains-'));
    try {
      const file = join(dir, 'EulerChains.json');
      writeFileSync(file, JSON.stringify(payload));
      execFileSync(process.execPath, [validatorPath, file], { stdio: 'pipe' });
      return { status: 0, stderr: '' };
    } catch (error) {
      return { status: error.status, stderr: String(error.stderr) };
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  };

  it('exits 0 for a valid file', () => {
    assert.equal(run([row({ chainId: 1, name: 'ethereum', viemName: 'mainnet', explorerUrl: 'https://etherscan.io' })]).status, 0);
  });

  it('exits 1 and reports each problem for an invalid file', () => {
    const result = run([row({ chainId: 8453, name: 'base', status: 'testing', explorerUrl: 'https://basescan.org/' })]);
    assert.equal(result.status, 1);
    assert.match(result.stderr, /chain 8453 \(base\): status "testing"/);
    assert.match(result.stderr, /chain 8453 \(base\): explorerUrl .* must not end with a slash/);
    assert.match(result.stderr, /chain 8453 \(base\): viem has several chains with id 8453/);
  });
});
