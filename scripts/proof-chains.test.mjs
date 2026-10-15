import { test } from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SCRIPT = resolve(dirname(fileURLToPath(import.meta.url)), 'proof-chains.mjs');
const git = (cwd, ...args) => execFileSync('git', ['-c', 'user.email=t@t', '-c', 'user.name=t', ...args], { cwd, encoding: 'utf8' });

const write = (root, path, value) => {
  mkdirSync(dirname(join(root, path)), { recursive: true });
  writeFileSync(join(root, path), typeof value === 'string' ? value : JSON.stringify(value, null, 1));
};

const BASE_FILES = {
  'addresses/1/CoreAddresses.json': { evc: '0x01' },
  'addresses/8453/CoreAddresses.json': { evc: '0x02' },
  'addresses/test/2818/CoreAddresses.json': { evc: '0x03' },
  'verify/manifest.json': { 1: { evc: { commit: 'a' } }, 8453: { evc: { commit: 'a' } } },
  'verify/baselines.json': { components: [] },
  'EulerChains.json': [
    { chainId: 1, name: 'ethereum' },
    { chainId: 8453, name: 'base' },
  ],
  'README.md': 'readme\n',
};

/**
 * GitHub's pull_request checkout: a merge commit of the PR into its base,
 * cloned with depth 2, so HEAD^1 is the base tip. Returns the script output.
 */
const prove = (changes, args = []) => {
  const work = mkdtempSync(join(tmpdir(), 'proof-chains-'));
  try {
    const origin = join(work, 'origin');
    mkdirSync(origin);
    git(origin, 'init', '-q', '-b', 'master');
    for (const [path, value] of Object.entries(BASE_FILES)) write(origin, path, value);
    git(origin, 'add', '.');
    git(origin, 'commit', '-qm', 'base');
    git(origin, 'checkout', '-qb', 'pr');
    for (const [path, value] of Object.entries(changes)) write(origin, path, value);
    git(origin, 'add', '.');
    git(origin, 'commit', '-qm', 'pr');
    git(origin, 'checkout', '-q', 'master');
    write(origin, 'unrelated.txt', 'base moved on\n');
    git(origin, 'add', '.');
    git(origin, 'commit', '-qm', 'base moved');
    git(origin, 'merge', '-q', '--no-ff', '-m', 'merge pr', 'pr');
    const clone = join(work, 'clone');
    execFileSync('git', ['clone', '-q', '--depth', '2', `file://${origin}`, clone]);
    return execFileSync('node', [SCRIPT, ...args], { cwd: clone, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
};

test('address files select their chains; addresses/test is ignored', () => {
  assert.equal(
    prove({
      'addresses/1/CoreAddresses.json': { evc: '0x11' },
      'addresses/8453/CoreAddresses.json': { evc: '0x22' },
      'addresses/test/2818/CoreAddresses.json': { evc: '0x33' },
    }),
    '1,8453',
  );
});

test('a manifest-only change selects the chains whose entries changed', () => {
  assert.equal(prove({ 'verify/manifest.json': { 1: { evc: { commit: 'a' } }, 8453: { evc: { commit: 'b' } } } }), '8453');
});

test('a config-only change selects its chain', () => {
  assert.equal(prove({ 'config/addresses/8453/CoreAddresses.json': { evc: '0x44' } }), '8453');
});

test('a registry-only change selects the chain whose row changed', () => {
  assert.equal(
    prove({
      'EulerChains.json': [
        { chainId: 1, name: 'ethereum', explorerUrl: 'https://etherscan.io' },
        { chainId: 8453, name: 'base' },
      ],
    }),
    '1',
  );
});

test('a baselines, audits or workflow change selects every chain', () => {
  assert.equal(prove({ 'verify/baselines.json': { components: [{ component: 'evc' }] } }), '1,8453');
  assert.equal(prove({ 'verify/audits.json': [] }), '1,8453');
  assert.equal(prove({ '.github/workflows/deployed-code-verification.yml': 'name: x\n' }), '1,8453');
});

test('an unrelated change selects no chain', () => {
  assert.equal(prove({ 'README.md': 'changed\n' }), '');
});

test('when the diff cannot be computed, every chain is selected', () => {
  assert.equal(prove({ 'README.md': 'changed\n' }, ['--base', 'HEAD~5']), '1,8453');
});
