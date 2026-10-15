let chains = [
  {
    chainId: 1,
    name: 'ethereum',
    viemName: 'mainnet',
    explorerUrl: 'https://etherscan.io',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'eth',
    status: 'production',
  },

  {
    chainId: 8453,
    name: 'base',
    viemName: 'base',
    explorerUrl: 'https://basescan.org',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'base',
    status: 'production',
  },

  {
    chainId: 146,
    name: 'sonic',
    explorerUrl: 'https://sonicscan.org',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'sonic',
    status: 'deprecated',
  },

  {
    chainId: 60808,
    name: 'BOB',
    viemName: 'bob',
    explorerUrl: 'https://explorer.gobob.xyz',
    verifier: { type: 'sourcify', url: 'https://contracts.conduit.xyz' },
    safeBaseUrl: 'https://safe.gobob.xyz',
    safeAddressPrefix: 'bob',
    status: 'deprecated',
  },

  {
    chainId: 80094,
    name: 'berachain',
    explorerUrl: 'https://berascan.com',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://safe.berachain.com',
    safeAddressPrefix: 'berachain',
    status: 'deprecated',
  },

  {
    chainId: 43114,
    name: 'avalanche',
    explorerUrl: 'https://snowtrace.io',
    verifier: { type: 'custom', url: 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'avax',
    status: 'production',
  },

  {
    chainId: 56,
    name: 'BSC',
    viemName: 'bsc',
    explorerUrl: 'https://bscscan.com',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'bnb',
    status: 'production',
  },

  {
    chainId: 130,
    name: 'unichain',
    explorerUrl: 'https://uniscan.xyz',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'unichain',
    status: 'production',
  },

  {
    chainId: 42161,
    name: 'arbitrum',
    explorerUrl: 'https://arbiscan.io',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'arb1',
    status: 'production',
  },

  {
    chainId: 239,
    name: 'TAC',
    viemName: 'tac',
    explorerUrl: 'https://explorer.tac.build',
    verifier: { type: 'blockscout', url: 'https://explorer.tac.build/api' },
    safeBaseUrl: 'https://safe.tac.build',
    safeAddressPrefix: 'tac',
    status: 'deprecated',
  },

  {
    chainId: 59144,
    name: 'linea',
    explorerUrl: 'https://lineascan.build',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'linea',
    status: 'production',
  },

  {
    chainId: 999,
    name: 'hyperEVM',
    viemName: 'hyperEvm',
    explorerUrl: 'https://hyperevmscan.io',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'hyper-evm',
    status: 'production',
  },

  {
    chainId: 9745,
    name: 'plasma',
    explorerUrl: 'https://plasmascan.to',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'plasma',
    status: 'production',
  },

  {
    chainId: 143,
    name: 'monad',
    explorerUrl: 'https://monadscan.com',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'monad',
    status: 'production',
  },

  {
    chainId: 137,
    name: 'polygon',
    explorerUrl: 'https://polygonscan.com',
    verifier: { type: 'etherscan' },
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'matic',
    status: 'unlisted',
  },
];




const fs = require("node:fs");

for (const c of chains) {
  const addrsDirs = [
    `./addresses/${c.chainId}/`,
    `./config/addresses/${c.chainId}/`
  ];

  c.addresses = {};

  for (const addrsDir of addrsDirs) {
    if (!fs.existsSync(addrsDir)) continue;
    for (const file of fs.readdirSync(addrsDir)) {
      if (!file.endsWith('Addresses.json')) continue;
      let section = file.replace(/Addresses[.]json$/, 'Addrs');
      section = section.charAt(0).toLowerCase() + section.slice(1);
      const newAddrs = JSON.parse(fs.readFileSync(`${addrsDir}/${file}`).toString());
      if (c.addresses[section]) {
        Object.assign(c.addresses[section], newAddrs);
      } else {
        c.addresses[section] = newAddrs;
      }
    }
  }
}

fs.writeFileSync('./EulerChains.json', JSON.stringify(chains));
