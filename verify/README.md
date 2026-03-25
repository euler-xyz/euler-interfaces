# Euler Contract Verification Reports

## Production Networks

| Network | Chain ID | Status | Contracts | Notes |
|---------|----------|--------|-----------|-------|
| [Mainnet](mainnet.md) | 1 | ✅ 100% | 26/26 | |
| [Arbitrum](arbitrum.md) | 42161 | ✅ 100% | 26/26 | |
| [Base](base.md) | 8453 | ✅ 100% | 26/26 | |
| [BSC](bsc.md) | 56 | ✅ 100% | 26/26 | |
| [Avalanche](avalanche.md) | 43114 | ✅ 100% | 26/26 | |
| [Linea](linea.md) | 59144 | ⚠️ 96% | 25/26 | eulerEarnFactory: 24KB optimizations |
| [Swell](swell.md) | 1923 | ✅ 100% | 26/26 | |
| [Sonic](sonic.md) | 146 | ✅ 100% | 26/26 | |
| [Bob](bob.md) | 60808 | ✅ 100% | 26/26 | |
| [Berachain](berachain.md) | 80094 | ✅ 100% | 26/26 | |
| [Unichain](unichain.md) | 130 | ✅ 100% | 26/26 | |
| [Monad](monad.md) | 143 | ✅ 100% | 21/21 | |
| [TAC](tac.md) | 239 | ✅ 100% | 26/26 | |
| [Plasma](plasma.md) | 9745 | ⚠️ 27% | 7/26 | Most contracts not verified on explorer |

## Report Structure

Each report contains:

1. **Summary table** — all contracts with address, source repo, deployment commit, evk-periphery ref, and file match count
2. **Changes Since Deployment** — diffs between the deployment commit and current `master`, scoped to only the files that are part of each deployed contract

## Running Verification

```bash
# Verify a single network
uv run python verify.py mainnet

# Verify all production networks
uv run python verify.py --all

# Deep search through git history
uv run python verify.py mainnet --exhaustive

# List available networks
uv run python verify.py --list
```

## Notes

### Linea (96%)
- **eulerEarnFactory**: Deployed with 24KB size optimizations (commented out `setName`/`setSymbol`)

### Plasma (27%)
- Most contracts are not yet verified on the Plasma block explorer
