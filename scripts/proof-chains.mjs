import { execFileSync } from 'node:child_process';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Any change to these proves every chain: they change the verifier itself, or what every report checks against.
const PROVE_ALL = new Set([
  '.github/workflows/deployed-code-verification.yml',
  'scripts/proof-chains.mjs',
  'verify/baselines.json',
  'verify/audits.json',
]);

const git = (args) => execFileSync('git', args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], maxBuffer: 256 * 1024 * 1024 });

const showJson = (rev, path) => {
  try {
    return JSON.parse(git(['show', `${rev}:${path}`]));
  } catch (error) {
    if (/does not exist|exists on disk, but not in/.test(String(error.stderr ?? ''))) return undefined;
    throw error;
  }
};

const canonical = (value) => {
  if (Array.isArray(value)) return `[${value.map(canonical).join(',')}]`;
  if (value !== null && typeof value === 'object') {
    return `{${Object.keys(value).sort().map((k) => `${JSON.stringify(k)}:${canonical(value[k])}`).join(',')}}`;
  }
  return JSON.stringify(value);
};

const changedKeys = (before = {}, after = {}) =>
  [...new Set([...Object.keys(before), ...Object.keys(after)])].filter((k) => canonical(before[k]) !== canonical(after[k]));

const registryByChain = (rows) => Object.fromEntries((Array.isArray(rows) ? rows : []).map((row) => [String(row.chainId), row]));

const chainFolders = (head, path) => {
  try {
    return git(['ls-tree', '--name-only', `${head}:${path}`]).split('\n').filter((name) => /^\d+$/.test(name));
  } catch (error) {
    if (/Not a valid object name/.test(String(error.stderr ?? ''))) return [];
    throw error;
  }
};

/** Chains the head can prove: manifest entries, and address files under addresses/ or config/addresses/ (chains.js publishes either). */
export const provableChains = (head) => {
  const manifest = showJson(head, 'verify/manifest.json') ?? {};
  return [...new Set([...chainFolders(head, 'addresses'), ...chainFolders(head, 'config/addresses')])]
    .filter((name) => manifest[name])
    .sort((a, b) => Number(a) - Number(b));
};

/**
 * Chains whose verification inputs differ between base and head: address
 * files, config/addresses overlays, the chain's manifest entries and its
 * EulerChains.json row. Every provable chain when the verifier, its baselines
 * or audits change, or when the diff can't be computed.
 */
export const proofChains = (base, head) => {
  const all = provableChains(head);
  let files;
  try {
    files = git(['diff', '--name-only', base, head]).split('\n').filter(Boolean);
  } catch (error) {
    return { chains: all, reason: `cannot diff ${base}..${head}: ${String(error.stderr ?? error.message).trim().split('\n')[0]}` };
  }
  const trigger = files.find((file) => PROVE_ALL.has(file));
  if (trigger) return { chains: all, reason: `${trigger} changed` };

  const selected = new Set();
  for (const file of files) {
    const m = /^(?:config\/)?addresses\/(\d+)\//.exec(file);
    if (m) selected.add(m[1]);
  }
  try {
    if (files.includes('verify/manifest.json')) {
      changedKeys(showJson(base, 'verify/manifest.json'), showJson(head, 'verify/manifest.json')).forEach((c) => selected.add(c));
    }
    if (files.includes('EulerChains.json')) {
      changedKeys(registryByChain(showJson(base, 'EulerChains.json')), registryByChain(showJson(head, 'EulerChains.json'))).forEach((c) => selected.add(c));
    }
  } catch (error) {
    return { chains: all, reason: `cannot compare the manifest or registry: ${String(error.message).split('\n')[0]}` };
  }
  return { chains: all.filter((c) => selected.has(c)), reason: 'changed verification inputs' };
};

const main = (argv) => {
  const flag = (name, fallback) => {
    const i = argv.indexOf(name);
    return i === -1 ? fallback : argv[i + 1];
  };
  const { chains, reason } = proofChains(flag('--base', 'HEAD^1'), flag('--head', 'HEAD'));
  process.stderr.write(`proof chains (${reason}): ${chains.join(',') || 'none'}\n`);
  process.stdout.write(`${chains.join(',')}\n`);
};

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main(process.argv.slice(2));
}
