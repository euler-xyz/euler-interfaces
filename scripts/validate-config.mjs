import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { basename, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ADDRESS = /^0x[0-9a-fA-F]{40}$/;
const CHAIN_ID = /^[1-9]\d*$/;
// evk-periphery's option 50 bridges EUL hub and spoke through Ethereum (HUB_CHAIN_ID = 1).
const HUB = 1;

const isRecord = (value) => typeof value === 'object' && value !== null && !Array.isArray(value);
const isAddress = (value) => typeof value === 'string' && ADDRESS.test(value);

const signerProblems = (name, signers, names) => {
  const seen = new Set();
  return signers.flatMap((signer) => {
    const key = isAddress(signer) ? signer.toLowerCase() : signer;
    if (seen.has(key)) return [`${name}: signer ${signer} is listed twice`];
    seen.add(key);
    if (isAddress(signer) || (typeof signer === 'string' && signer !== name && names.has(signer))) return [];
    return [`${name}: signer ${JSON.stringify(signer)} is neither an address nor the name of another file in config/multisig`];
  });
};

const multisigProblems = (name, multisig, names) => {
  if (!isRecord(multisig)) return [`${name}: must be an object with threshold and signers`];
  const extra = Object.keys(multisig).filter((key) => key !== 'threshold' && key !== 'signers');
  const problems = extra.length ? [`${name}: only threshold and signers are allowed, found ${extra.join(', ')}`] : [];
  const { signers, threshold } = multisig;
  if (!Array.isArray(signers) || signers.length === 0) return [...problems, `${name}: signers must be a non-empty list`];
  const thresholdOk = Number.isInteger(threshold) && threshold >= 1 && threshold <= signers.length;
  return [
    ...problems,
    ...signerProblems(name, signers, names),
    ...(thresholdOk ? [] : [`${name}: threshold must be an integer from 1 to the number of signers (${signers.length})`]),
  ];
};

const cycleFrom = (start, edges) => {
  const walk = (node, path) => {
    for (const next of edges.get(node) ?? []) {
      if (next === start) return [...path, next];
      if (!path.includes(next)) {
        const found = walk(next, [...path, next]);
        if (found) return found;
      }
    }
    return null;
  };
  return walk(start, [start]);
};

/** Problems in `config/multisig/*.json`, given as { <file name without .json>: contents }. */
export const validateMultisigs = (configs) => {
  const names = new Set(Object.keys(configs));
  const edges = new Map(
    Object.entries(configs).map(([name, multisig]) => [
      name,
      Array.isArray(multisig?.signers) ? multisig.signers.filter((signer) => signer !== name && names.has(signer)) : [],
    ]),
  );
  const cycles = [...names].sort().flatMap((name) => {
    const cycle = cycleFrom(name, edges);
    return cycle && [...cycle].sort()[0] === name ? [`${name}: signers form a cycle (${cycle.join(' -> ')})`] : [];
  });
  return [...Object.entries(configs).flatMap(([name, multisig]) => multisigProblems(name, multisig, names)), ...cycles];
};

const chainName = (id) => (id === HUB ? 'Ethereum' : String(id));

const topologyProblems = (token, rows) => {
  const hubList = rows.get(HUB) ?? [];
  const spokes = [...rows.keys()].filter((id) => id !== HUB);
  return [
    ...spokes.flatMap((id) => {
      const listed = [...new Set(rows.get(id))];
      return listed.length === 1 && listed[0] === HUB ? [] : [`${token}: ${id} may only list Ethereum (1); spokes are bridged only to Ethereum`];
    }),
    ...[...new Set(hubList)]
      .filter((id) => !(rows.get(id) ?? []).includes(HUB))
      .map((id) => `${token}: ${chainName(HUB)} lists ${id}, but ${id} does not list ${chainName(HUB)}`),
    ...spokes
      .filter((id) => rows.get(id).includes(HUB) && !hubList.includes(id))
      .map((id) => `${token}: ${id} lists ${chainName(HUB)}, but ${chainName(HUB)} does not list ${id}`),
  ];
};

const tokenProblems = (token, sources, chainIds) => {
  if (!isRecord(sources)) return [`${token}: must map source chain ids to destination chain ids`];
  const problems = [];
  const rows = new Map();
  for (const [source, destinations] of Object.entries(sources)) {
    if (!CHAIN_ID.test(source)) problems.push(`${token}: source ${JSON.stringify(source)} must be a chain id`);
    else if (!Array.isArray(destinations) || !destinations.every((id) => Number.isSafeInteger(id) && id > 0)) {
      problems.push(`${token}: ${source} must list destination chain ids`);
    } else rows.set(Number(source), destinations);
  }
  const pairProblems = [...rows].flatMap(([id, destinations]) => [
    ...(destinations.includes(id) ? [`${token}: ${id} lists itself`] : []),
    ...[...new Set(destinations.filter((other, index) => destinations.indexOf(other) !== index))].map(
      (other) => `${token}: ${id} lists ${other} twice`,
    ),
  ]);
  const ids = [...new Set([...rows.keys(), ...[...rows.values()].flat()])].sort((a, b) => a - b);
  const folderProblems = ids
    .filter((id) => !chainIds.has(id))
    .map((id) => `${token}: ${id} has no addresses/${id}/ or config/addresses/${id}/ folder`);
  const earlier = [...problems, ...pairProblems, ...folderProblems];
  return earlier.length ? earlier : topologyProblems(token, rows);
};

/** Problems in `config/bridge/BridgeConfigCache.json`; `chainIds` are the chains with address files. */
export const validateBridgeCache = (cache, chainIds) =>
  isRecord(cache)
    ? Object.entries(cache).flatMap(([token, sources]) => tokenProblems(token, sources, chainIds))
    : ['the bridge cache must map each token to its source chains'];

const readJson = (root, file) => {
  try {
    return JSON.parse(readFileSync(join(root, file), 'utf8'));
  } catch (error) {
    console.error(`::error file=${file}::cannot read ${file}: ${error.message}`);
    process.exit(1);
  }
};

const chainFolders = (root) =>
  new Set(
    ['addresses', join('config', 'addresses')]
      .filter((dir) => existsSync(join(root, dir)))
      .flatMap((dir) => readdirSync(join(root, dir)).filter((entry) => CHAIN_ID.test(entry)).map(Number)),
  );

const main = (root) => {
  const multisigDir = join('config', 'multisig');
  const multisigFiles = existsSync(join(root, multisigDir)) ? readdirSync(join(root, multisigDir)).filter((f) => f.endsWith('.json')) : [];
  const configs = Object.fromEntries(multisigFiles.map((file) => [basename(file, '.json'), readJson(root, join(multisigDir, file))]));
  const bridgeFile = join('config', 'bridge', 'BridgeConfigCache.json');
  const problems = [
    ...validateMultisigs(configs).map((problem) => [join(multisigDir, `${problem.split(':')[0]}.json`), problem]),
    ...(existsSync(join(root, bridgeFile))
      ? validateBridgeCache(readJson(root, bridgeFile), chainFolders(root)).map((problem) => [bridgeFile, problem])
      : []),
  ];
  if (problems.length > 0) {
    for (const [file, problem] of problems) console.error(`::error file=${file}::${problem}`);
    process.exit(1);
  }
  process.stdout.write(`config/multisig (${multisigFiles.length} files) and the bridge cache are valid\n`);
};

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main(resolve(process.argv[2] ?? '.'));
}
