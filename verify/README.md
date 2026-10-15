# Deployed Code Verification Reports

Bytecode-level verification of every allowlisted Euler contract: on-chain runtime code is proven equal to a commit-pinned local build (metadata trailer stripped; immutables and build-located embedded metadata digests masked) — the block explorer is never in the trust path — then each deployment is diffed against its component's audited baseline: the fixes-included state of the component's most recent audit. Reports lead with anything requiring attention and show every deployed source delta beyond audited code as a real diff. Reproducible by anyone. The claim is runtime correspondence under this normalization, not initialization, governance, immutable configuration or deployment safety.

| Network | Chain ID | Proven |
|---------|----------|--------|
| [Ethereum](1.md) | 1 | 20/21 (+1 canonical) |
| [BNB Smart Chain](56.md) | 56 | 21/21 |
| [Unichain](130.md) | 130 | 21/21 |
| [Polygon](137.md) | 137 | 10/10 |
| [Monad](143.md) | 143 | 16/16 |
| [Sonic](146.md) | 146 | 21/21 |
| [TAC](239.md) | 239 | 21/21 |
| [HyperEVM](999.md) | 999 | 18/18 |
| [Base](8453.md) | 8453 | 21/21 |
| [Plasma](9745.md) | 9745 | 21/21 |
| [Arbitrum One](42161.md) | 42161 | 21/21 |
| [Avalanche](43114.md) | 43114 | 21/21 |
| [Linea Mainnet](59144.md) | 59144 | 21/21 |
| [BOB](60808.md) | 60808 | 21/21 |
| [Berachain](80094.md) | 80094 | 21/21 |

_Inputs: `manifest.json` (declared provenance, SHA-only), `audits.json` (audit registry), `baselines.json` (component baselines with derivations). Regenerated only when a PR changes those inputs or addresses._
