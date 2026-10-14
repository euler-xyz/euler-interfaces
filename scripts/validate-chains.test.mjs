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
  VERIFIER_TYPES,
  explorerUrlProblem,
  statusProblem,
  validateChains,
  verifierProblem,
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
  verifier: { type: 'sourcify' },
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

describe('verifierProblem', () => {
  it('lists exactly the four verifier types', () => {
    assert.deepEqual([...VERIFIER_TYPES], ['etherscan', 'blockscout', 'sourcify', 'custom']);
  });

  it('accepts each type with its url rule', () => {
    for (const verifier of [
      { type: 'etherscan' },
      { type: 'blockscout', url: 'https://explorer.one.example/api' },
      { type: 'sourcify' },
      { type: 'sourcify', url: 'https://sourcify.one.example' },
      { type: 'custom', url: 'https://api.one.example/v2/network/mainnet/evm/10/etherscan/api' },
    ]) {
      assert.equal(verifierProblem(verifier), null, JSON.stringify(verifier));
    }
  });

  it('rejects a missing verifier', () => {
    assert.match(verifierProblem(undefined), /verifier is missing; use one of etherscan, blockscout, sourcify, custom/);
  });

  it('rejects an unknown type or a value that is not an object', () => {
    assert.match(verifierProblem({ type: 'routescan' }), /verifier type "routescan" is not one of etherscan, blockscout, sourcify, custom/);
    assert.match(verifierProblem(null), /verifier type null is not one of/);
    assert.match(verifierProblem('etherscan'), /verifier type "etherscan" is not one of/);
    assert.match(verifierProblem([{ type: 'etherscan' }]), /is not one of/);
  });

  it('rejects an unknown field', () => {
    assert.match(verifierProblem({ type: 'etherscan', apiKey: 'x' }), /verifier etherscan has unknown field apiKey/);
  });

  it('requires a url for blockscout and custom', () => {
    assert.match(verifierProblem({ type: 'blockscout' }), /verifier blockscout needs a url/);
    assert.match(verifierProblem({ type: 'custom' }), /verifier custom needs a url/);
    assert.match(verifierProblem({ type: 'custom', url: '' }), /verifier custom needs a url/);
  });

  it('rejects a url on etherscan', () => {
    assert.match(verifierProblem({ type: 'etherscan', url: 'https://api.etherscan.io/v2/api' }), /verifier etherscan takes no url/);
  });

  it('rejects a url that is not canonical https', () => {
    assert.match(verifierProblem({ type: 'blockscout', url: 'explorer.one.example/api' }), /is not a URL/);
    assert.match(verifierProblem({ type: 'blockscout', url: 'http://explorer.one.example/api' }), /must use https/);
    for (const url of [
      'https://explorer.one.example/api/',
      'https://explorer.one.example/',
      'https://explorer.one.example/api?apikey=x',
      'https://explorer.one.example/api#top',
      'https://user:pass@explorer.one.example/api',
      'https://Explorer.one.example/api',
      'https://explorer.one.example:443/api',
    ]) {
      assert.match(verifierProblem({ type: 'blockscout', url }), /must be a canonical https URL/, url);
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

  it('resolves every duplicate id in the pinned viem only through one of its names', () => {
    const ids = [...new Set(Object.values(viemChains).filter((chain) => typeof chain?.id === 'number').map((chain) => chain.id))];
    for (const chainId of ids) {
      const names = Object.entries(viemChains)
        .filter(([, chain]) => typeof chain?.id === 'number' && chain.id === chainId && chain.rpcUrls?.default)
        .map(([name]) => name);
      if (new Set(names.map((name) => viemChains[name])).size < 2) continue;
      assert.match(viemChainProblem({ chainId }, viemChains), /viem has several chains with id/, String(chainId));
      assert.equal(viemChainProblem({ chainId, viemName: names[0] }, viemChains), null, String(chainId));
    }
  });
});

describe('validateChains', () => {
  it('returns no problems for valid rows', () => {
    assert.deepEqual(validateChains([row(), row({ chainId: 20, name: 'two', viemName: 'twinB' })], catalog), []);
  });

  it('prefixes each problem with the chain it belongs to', () => {
    const problems = validateChains(
      [row({ chainId: 20, name: 'two', status: 'testing', explorerUrl: 'https://two.example/', verifier: undefined })],
      catalog,
    );
    assert.equal(problems.length, 4);
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
    const result = run([
      row({ chainId: 1, name: 'ethereum', viemName: 'mainnet', status: 'testing', explorerUrl: 'https://etherscan.io/', verifier: { type: 'custom' } }),
    ]);
    assert.equal(result.status, 1);
    assert.match(result.stderr, /chain 1 \(ethereum\): status "testing"/);
    assert.match(result.stderr, /chain 1 \(ethereum\): explorerUrl .* must not end with a slash/);
    assert.match(result.stderr, /chain 1 \(ethereum\): verifier custom needs a url/);
  });
});
