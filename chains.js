let chains = [
  {
    chainId: 1,
    name: 'ethereum',
    viemName: 'mainnet',
    explorerUrl: 'https://etherscan.io',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'eth',
    status: 'production',
  },

  {
    chainId: 8453,
    name: 'base',
    viemName: 'base',
    explorerUrl: 'https://basescan.org',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'base',
    status: 'production',
  },

  {
    chainId: 146,
    name: 'sonic',
    explorerUrl: 'https://sonicscan.org',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'sonic',
    status: 'deprecated',
  },

  {
    chainId: 60808,
    name: 'BOB',
    viemName: 'bob',
    explorerUrl: 'https://explorer.gobob.xyz',
    safeBaseUrl: 'https://safe.gobob.xyz',
    safeAddressPrefix: 'bob',
    status: 'deprecated',
  },

  {
    chainId: 80094,
    name: 'berachain',
    explorerUrl: 'https://berascan.com',
    safeBaseUrl: 'https://safe.berachain.com',
    safeAddressPrefix: 'berachain',
    status: 'deprecated',
  },

  {
    chainId: 43114,
    name: 'avalanche',
    explorerUrl: 'https://snowtrace.io',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'avax',
    status: 'production',
  },

  {
    chainId: 56,
    name: 'BSC',
    viemName: 'bsc',
    explorerUrl: 'https://bscscan.com',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'bnb',
    status: 'production',
  },

  {
    chainId: 130,
    name: 'unichain',
    explorerUrl: 'https://uniscan.xyz',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'unichain',
    status: 'production',
  },

  {
    chainId: 42161,
    name: 'arbitrum',
    explorerUrl: 'https://arbiscan.io',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'arb1',
    status: 'production',
  },

  {
    chainId: 239,
    name: 'TAC',
    viemName: 'tac',
    explorerUrl: 'https://explorer.tac.build',
    safeBaseUrl: 'https://safe.tac.build',
    safeAddressPrefix: 'tac',
    status: 'deprecated',
  },

  {
    chainId: 59144,
    name: 'linea',
    explorerUrl: 'https://lineascan.build',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'linea',
    status: 'production',
  },

  {
    chainId: 999,
    name: 'hyperEVM',
    viemName: 'hyperEvm',
    explorerUrl: 'https://hyperevmscan.io',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'hyper-evm',
    status: 'production',
  },

  {
    chainId: 9745,
    name: 'plasma',
    explorerUrl: 'https://plasmascan.to',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'plasma',
    status: 'production',
  },

  {
    chainId: 143,
    name: 'monad',
    explorerUrl: 'https://monadscan.com',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'monad',
    status: 'production',
  },

  {
    chainId: 137,
    name: 'polygon',
    explorerUrl: 'https://polygonscan.com',
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
