# Deployed Code Verification Reports

Bytecode-level verification of the contracts on the euler-verifier allowlist: on-chain runtime code is proven equal to a commit-pinned local build (metadata trailer stripped; immutables and build-located embedded metadata digests masked), and block explorers are not trusted. Each deployment is then diffed against its component's audited baseline, the fixes-included state of the last audit that reviewed the whole component, and against the audited baselines of the Euler libraries compiled into it. Third-party dependencies are not compared. The claim is runtime correspondence under this normalization, not initialization, governance, immutable configuration or deployment safety.

| Network | Chain ID | Bytecode-proven (of contracts in scope) |
|---------|----------|-----------------------------------------|
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

_Inputs: `manifest.json` (declared provenance, SHA-only), `audits.json` (audit registry), `baselines.json` (component baselines with derivations), and euler-verifier `manifests/attention-notes.json`. Regenerated only when a PR changes those inputs or addresses._
