let chains = [
  //// PRODUCTION
  {
    chainId: 999,
    name: 'hyperEvm',
    safeBaseUrl: 'https://safe.onchainden.com',
    safeAddressPrefix: 'hyperevm',
    status: 'production',
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
