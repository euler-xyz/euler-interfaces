# Deployed Code Verification Reports

Each report shows whether the code deployed on a chain is the code built from a specific commit, and how that code differs from its audited version. Matches are byte-for-byte rebuilds; block explorers are not trusted. Euler's shared libraries are compared with their own audited versions; third-party libraries are not compared. A match says nothing about how a contract was initialised or configured, or who controls it.

| Network | Chain ID | Bytecode matches (of contracts in scope) |
|---------|----------|------------------------------------------|
| [Ethereum](1.md) | 1 | 22 of 23 · 1 canonical |
| [BNB Smart Chain](56.md) | 56 | 22 of 22 |
| [Unichain](130.md) | 130 | 22 of 22 |
| [Polygon](137.md) | 137 | 11 of 11 |
| [Monad](143.md) | 143 | 17 of 17 |
| [Sonic](146.md) | 146 | 21 of 21 |
| [TAC](239.md) | 239 | 21 of 21 |
| [HyperEVM](999.md) | 999 | 19 of 19 |
| [Base](8453.md) | 8453 | 22 of 22 |
| [Plasma](9745.md) | 9745 | 22 of 22 |
| [Arbitrum One](42161.md) | 42161 | 22 of 22 |
| [Avalanche](43114.md) | 43114 | 22 of 22 |
| [Linea Mainnet](59144.md) | 59144 | 22 of 22 |
| [BOB](60808.md) | 60808 | 21 of 21 |
| [Berachain](80094.md) | 80094 | 21 of 21 |

_Inputs: `manifest.json` (the source commit of each contract), `audits.json` (the audits), `baselines.json` (the audited version of each product and library), and euler-verifier `manifests/attention-notes.json` (Euler notes). Regenerated only when a PR changes those inputs or the addresses._
