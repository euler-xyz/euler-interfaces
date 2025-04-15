let chains = [
  //// PRODUCTION

  {
    chainId: 1,
    name: 'mainnet',
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
    name: 'bob',
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
    name: 'bnb',
    viemName: 'bsc',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'bnb',
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
    chainId: 130,
    name: 'unichain',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'unichain',
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
    chainId: 42161,
    name: 'arbitrum',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'arb1',
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
    chainId: 57073,
    name: 'ink',
    safeBaseUrl: 'https://app.safe.global',
    safeAddressPrefix: 'ink',
    status: 'testing',
  },
];




const fs = require("node:fs");

for (let c of chains) {
    let addrsDir = `./addresses/${c.chainId}/`;

    c.addresses = {};

    for (const file of fs.readdirSync(addrsDir)) {
        if (!file.endsWith('Addresses.json')) continue;
        let section = file.replace(/Addresses[.]json$/, 'Addrs');
        section = (section[0] + '').toLowerCase() + section.substr(1);
        c.addresses[section] = JSON.parse(fs.readFileSync(`${addrsDir}/${file}`).toString());
    }
}

fs.writeFileSync('./EulerChains.json', JSON.stringify(chains));
