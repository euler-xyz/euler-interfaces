import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { cpSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { validateBridgeCache, validateMultisigs } from './validate-config.mjs';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));
const validatorPath = fileURLToPath(new URL('./validate-config.mjs', import.meta.url));

const A = '0x6dfbE28bbAAa8D52d8826c0b402898E578B1E58e';
const B = '0x42360aA7A906aCb052EfE82fcbC2180eB09aeF60';
const C = '0x6901bECf23cf23C3866CaE6D8612f04358a4fc9a';

describe('validateMultisigs', () => {
  it('accepts address signers and signers named after other multisigs', () => {
    assert.deepEqual(
      validateMultisigs({
        DAO: { threshold: 2, signers: [A, B, C] },
        labs: { threshold: 1, signers: [A] },
        council: { threshold: 1, signers: ['labs', 'DAO'] },
      }),
      [],
    );
  });

  it('rejects a threshold outside 1..signers', () => {
    assert.deepEqual(validateMultisigs({ DAO: { threshold: 3, signers: [A, B] } }), [
      'DAO: threshold must be an integer from 1 to the number of signers (2)',
    ]);
    assert.deepEqual(validateMultisigs({ DAO: { threshold: 0, signers: [A] } }), [
      'DAO: threshold must be an integer from 1 to the number of signers (1)',
    ]);
  });

  it('rejects a signer that is neither an address nor another multisig, and duplicates', () => {
    assert.deepEqual(validateMultisigs({ DAO: { threshold: 1, signers: [A, A.toLowerCase(), 'nobody', 'DAO'] } }), [
      `DAO: signer ${A.toLowerCase()} is listed twice`,
      'DAO: signer "nobody" is neither an address nor the name of another file in config/multisig',
      'DAO: signer "DAO" is neither an address nor the name of another file in config/multisig',
    ]);
  });

  it('rejects other keys and an empty signer list', () => {
    assert.deepEqual(validateMultisigs({ DAO: { threshold: 1, signers: [], owner: A } }), [
      'DAO: only threshold and signers are allowed, found owner',
      'DAO: signers must be a non-empty list',
    ]);
  });

  it('rejects multisigs that sign for each other in a cycle', () => {
    assert.deepEqual(
      validateMultisigs({
        a: { threshold: 1, signers: ['b'] },
        b: { threshold: 1, signers: ['a'] },
      }),
      ['a: signers form a cycle (a -> b -> a)'],
    );
  });
});

describe('validateBridgeCache', () => {
  const chains = new Set([1, 130, 143]);

  it('accepts a hub-and-spoke cache recorded in both directions', () => {
    assert.deepEqual(validateBridgeCache({ EUL: { 1: [130, 143], 130: [1], 143: [1] } }, chains), []);
  });

  it('rejects a spoke listed by only one side', () => {
    assert.deepEqual(validateBridgeCache({ EUL: { 1: [130, 143], 130: [1] } }, chains), [
      'EUL: Ethereum lists 143, but 143 does not list Ethereum',
    ]);
    assert.deepEqual(validateBridgeCache({ EUL: { 1: [130], 130: [1], 143: [1] } }, chains), [
      'EUL: 143 lists Ethereum, but Ethereum does not list 143',
    ]);
  });

  it('rejects a spoke paired with another spoke', () => {
    assert.deepEqual(validateBridgeCache({ EUL: { 1: [130], 130: [1, 143] } }, chains), [
      'EUL: 130 may only list Ethereum (1); spokes are bridged only to Ethereum',
    ]);
  });

  it('rejects chains without address files, self pairs, duplicates and malformed ids', () => {
    assert.deepEqual(validateBridgeCache({ EUL: { 1: [1, 999, 130, 130], 130: [1], x: [1] } }, chains), [
      'EUL: source "x" must be a chain id',
      'EUL: 1 lists itself',
      'EUL: 1 lists 130 twice',
      'EUL: 999 has no addresses/999/ or config/addresses/999/ folder',
    ]);
  });

  it('rejects a file that is not token -> source -> destinations', () => {
    assert.deepEqual(validateBridgeCache([], chains), ['the bridge cache must map each token to its source chains']);
    assert.deepEqual(validateBridgeCache({ EUL: { 1: 130 } }, chains), ['EUL: 1 must list destination chain ids']);
  });
});

describe('command line', () => {
  const run = (setup) => {
    const dir = mkdtempSync(join(tmpdir(), 'validate-config-'));
    try {
      cpSync(join(repoRoot, 'config'), join(dir, 'config'), { recursive: true });
      cpSync(join(repoRoot, 'addresses'), join(dir, 'addresses'), { recursive: true });
      setup(dir);
      execFileSync(process.execPath, [validatorPath, dir], { stdio: 'pipe' });
      return { status: 0, stderr: '' };
    } catch (error) {
      return { status: error.status, stderr: String(error.stderr) };
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  };

  it("exits 0 for this repository's files", () => {
    assert.equal(run(() => {}).status, 0);
  });

  it('exits 1 and names the file for an invalid multisig or bridge cache', () => {
    const result = run((dir) => {
      writeFileSync(join(dir, 'config', 'multisig', 'labs.json'), JSON.stringify({ threshold: 9, signers: [A] }));
      mkdirSync(join(dir, 'config', 'bridge'), { recursive: true });
      writeFileSync(join(dir, 'config', 'bridge', 'BridgeConfigCache.json'), JSON.stringify({ EUL: { 1: [130] } }));
    });
    assert.equal(result.status, 1);
    assert.match(result.stderr, /file=config\/multisig\/labs.json::labs: threshold must be/);
    assert.match(result.stderr, /file=config\/bridge\/BridgeConfigCache.json::EUL: Ethereum lists 130, but 130 does not list Ethereum/);
  });
});
