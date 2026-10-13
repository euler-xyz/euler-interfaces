import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import * as viemChains from 'viem/chains';

export const CHAIN_STATUSES = Object.freeze(['staging', 'production', 'unlisted', 'deprecated']);

const isRecord = (value) => typeof value === 'object' && value !== null;

// Same shape test and resolution order as the SDK's chain resolution (euler-sdks
// providerService/chainResolution.ts), so a row that passes here resolves there.
const isViemChain = (value) =>
  isRecord(value) &&
  typeof value.id === 'number' &&
  typeof value.name === 'string' &&
  isRecord(value.nativeCurrency) &&
  isRecord(value.rpcUrls) &&
  isRecord(value.rpcUrls.default);

const viemChainsWithId = (catalog, chainId) => {
  const matches = Object.entries(catalog).filter(([, chain]) => isViemChain(chain) && chain.id === chainId);
  const distinct = [...new Set(matches.map(([, chain]) => chain))];
  return distinct.map((chain) => matches.filter(([, candidate]) => candidate === chain).map(([name]) => name));
};

export const statusProblem = (status) => {
  if (status === undefined) return `status is missing; use one of ${CHAIN_STATUSES.join(', ')}`;
  return CHAIN_STATUSES.includes(status)
    ? null
    : `status ${JSON.stringify(status)} is not one of ${CHAIN_STATUSES.join(', ')}`;
};

const parseUrl = (value) => {
  try {
    return new URL(value);
  } catch {
    return null;
  }
};

export const explorerUrlProblem = (value) => {
  if (typeof value !== 'string' || value.length === 0) return 'explorerUrl is missing';
  const url = parseUrl(value);
  if (!url) return `explorerUrl "${value}" is not a URL`;
  if (url.protocol !== 'https:') return `explorerUrl "${value}" must use https`;
  if (value.endsWith('/')) return `explorerUrl "${value}" must not end with a slash`;
  if (url.origin !== value) return `explorerUrl "${value}" must be an https origin such as https://etherscan.io`;
  return null;
};

export const viemChainProblem = ({ chainId, viemName }, catalog) => {
  if (viemName !== undefined) {
    if (typeof viemName !== 'string' || viemName.length === 0) return 'viemName must be a non-empty string';
    const named = Object.hasOwn(catalog, viemName) ? catalog[viemName] : undefined;
    return isViemChain(named) && named.id === chainId
      ? null
      : `viemName "${viemName}" is not a viem chain with id ${chainId}`;
  }
  const candidates = viemChainsWithId(catalog, chainId);
  if (candidates.length === 1) return null;
  if (candidates.length === 0) return `viem has no chain with id ${chainId}`;
  return `viem has several chains with id ${chainId} (${candidates.flat().join(', ')}); set viemName`;
};

const label = (chain) => `chain ${chain.chainId}${typeof chain.name === 'string' ? ` (${chain.name})` : ''}`;

const chainProblems = (chain, index, catalog) => {
  if (!isRecord(chain) || !Number.isSafeInteger(chain.chainId) || chain.chainId <= 0) {
    return [`row ${index}: chainId must be a positive integer`];
  }
  return [statusProblem(chain.status), explorerUrlProblem(chain.explorerUrl), viemChainProblem(chain, catalog)]
    .filter((problem) => problem !== null)
    .map((problem) => `${label(chain)}: ${problem}`);
};

export const validateChains = (chains, catalog) =>
  Array.isArray(chains)
    ? chains.flatMap((chain, index) => chainProblems(chain, index, catalog))
    : ['EulerChains.json must be a list of chains'];

const readJson = (file) => {
  try {
    return JSON.parse(readFileSync(file, 'utf8'));
  } catch (error) {
    console.error(`::error::cannot read ${file}: ${error.message}`);
    process.exit(1);
  }
};

const main = (file) => {
  const problems = validateChains(readJson(file), viemChains);
  if (problems.length > 0) {
    for (const problem of problems) console.error(`::error file=EulerChains.json::${problem}`);
    process.exit(1);
  }
  process.stdout.write(`${file}: every chain is valid\n`);
};

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main(process.argv[2] ?? 'EulerChains.json');
}
