let chains = [
  //// PRODUCTION

  {
    chainId: 1,
    name: 'ethereum',
    viemName: 'mainnet',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'eth',
    status: 'production',
  },

  {
    chainId: 8453,
    name: 'base',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'base',
    status: 'production',
  },

  {
    chainId: 1923,
    name: 'swell',
    viemName: 'swellchain',
    safeBaseUrl: 'https://safe.optimism.io',
    safeAddressPrefix: 'swell-l2',
    status: 'production',
  },

  {
    chainId: 146,
    name: 'sonic',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'sonic',
    status: 'production',
  },

  {
    chainId: 60808,
    name: 'BOB',
    viemName: 'bob',
    safeBaseUrl: 'https://safe.gobob.xyz',
    safeAddressPrefix: 'bob',
    status: 'production',
  },

  {
    chainId: 80094,
    name: 'berachain',
    safeBaseUrl: 'https://safe.berachain.com',
    safeAddressPrefix: 'berachain',
    status: 'production',
  },

  {
    chainId: 43114,
    name: 'avalanche',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'avax',
    status: 'production',
  },

  {
    chainId: 56,
    name: 'BSC',
    viemName: 'bsc',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'bnb',
    status: 'production',
  },

  {
    chainId: 130,
    name: 'unichain',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'unichain',
    status: 'production',
  },

  {
    chainId: 42161,
    name: 'arbitrum',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'arb1',
    status: 'production',
  },

  {
    chainId: 239,
    name: 'TAC',
    viemName: 'tac',
    safeBaseUrl: 'https://safe.tac.build',
    safeAddressPrefix: 'tac',
    status: 'production',
  },

  {
    chainId: 59144,
    name: 'linea',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'linea',
    status: 'production',
  },

  {
    chainId: 999,
    name: 'hyperEVM',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'hyper-evm',
    status: 'production',
  },

  {
    chainId: 9745,
    name: 'plasma',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'plasma',
    status: 'production',
  },

  {
    chainId: 143,
    name: 'monad',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'monad',
    status: 'production',
  },

  //// BETA

  //// TESTING

  {
    chainId: 10,
    name: 'optimism',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'oeth',
    status: 'testing',
  },

  {
    chainId: 100,
    name: 'gnosis',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'gno',
    status: 'testing',
  },

  {
    chainId: 137,
    name: 'polygon',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'matic',
    status: 'testing',
  },

  {
    chainId: 21000000,
    name: 'corn',
    safeBaseUrl: 'https://safe.usecorn.com',
    safeAddressPrefix: 'corn',
    status: 'testing',
  },

  {
    chainId: 2818,
    name: 'morph',
    safeBaseUrl: 'https://safe.morphl2.io/',
    safeAddressPrefix: 'morph',
    status: 'testing',
  },

  {
    chainId: 480,
    name: 'worldchain',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'wc',
    status: 'testing',
  },

  {
    chainId: 5000,
    name: 'mantle',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'mnt',
    status: 'testing',
  },

  {
    chainId: 57073,
    name: 'ink',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'ink',
    status: 'testing',
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
        // Merge new addresses into the existing section (shallow merge)
        Object.assign(c.addresses[section], newAddrs);
      } else {
        c.addresses[section] = newAddrs;
      }
    }
  }
}

fs.writeFileSync('./EulerChains.json', JSON.stringify(chains));
