# euler-interfaces

Canonical addresses, ABIs, and interface definitions for the deployed Euler
protocol contracts across all supported chains.

## ✅ Deployed Code Verification

Every security-relevant Euler contract is **verified at the bytecode level**:
the on-chain runtime code is proven equal to a build of an exact, recorded
source commit — block explorers are never in the trust path — and each
deployment is diffed against its component's most recent **audited baseline**,
so any code beyond audited revisions is visible as a real diff. The claim is
runtime correspondence under explicit normalization (metadata trailer
stripped; immutables and build-located embedded metadata digests masked), not
proof of initialization, governance, immutable configuration or deployment
safety.

**[Browse the per-chain verification reports →](verify/README.md)**

- [`verify/manifest.json`](verify/manifest.json) — source provenance for every
  contract (repo + commit SHA + build profile), bytecode-proven
- [`verify/audits.json`](verify/audits.json) — the audit registry backing the
  baselines
- [`verify/baselines.json`](verify/baselines.json) — one audited baseline per
  component, with derivations
- Reports are named by chain ID (e.g. [`verify/1.md`](verify/1.md) for
  Ethereum mainnet). Manifest entries and reports are generated with
  euler-verifier's `pnpm add-entries` in the PR that changes addresses (see
  [Adding or redeploying a contract](#adding-or-redeploying-a-contract)), never
  written by hand. CI checks that every deployed contract has an entry proven
  at its current address, and proves the bytecode, EVault modules and
  EulerSwap management contract of every chain whose verification inputs the
  PR changes: its address files, `config/addresses` overlay, manifest entries
  or `EulerChains.json` row (every chain when the verifier pin, workflow,
  baselines or audits change). It is a required check.

Anyone can reproduce the proofs with [euler-verifier](https://github.com/euler-xyz/euler-verifier)
using only public RPC endpoints — no API keys or secrets required.

## Layout

| Path | Contents |
|------|----------|
| `addresses/<chainId>/` | Deployed contract addresses per chain |
| `addresses/test/<chainId>/` | Testnet and retired-chain addresses, not published in `EulerChains.json` |
| `config/` | Address overlays, expected multisig configurations and bridge routes |
| `abis/` | Contract ABIs |
| `interfaces/` | Solidity interface definitions |
| `verify/` | Bytecode verification reports and provenance manifests |
| `EulerChains.json`, `chains.js` | Supported chain metadata (see [Adding a chain](#adding-a-chain)) |
| `scripts/` | `EulerChains.json` validator and the proof's chain selection, run by CI |

## Adding or redeploying a contract

The manifest entry and the report come from
[euler-verifier](https://github.com/euler-xyz/euler-verifier). It proves the
deployed bytecode against candidate commits and writes what proves.

1. Deploy. The deployment writes the address into your checkout of this repo
   under `addresses/<chainId>/`. Run `node chains.js`: the verifier checks
   the addresses consumers receive (with `config/addresses/` applied) and
   refuses an `EulerChains.json` that lags the address files.
2. Push the commit you deployed from; the verifier builds it from GitHub.
3. In a euler-verifier checkout (`pnpm install`, with `forge` on PATH), name
   the deploying checkout or the exact commit:

   ```bash
   pnpm add-entries --interfaces ../euler-interfaces --chain 8453 \
     --candidate euler-xyz/evk-periphery@<40-hex sha>
   ```

   `--candidates-from ../evk-periphery` offers that checkout's HEAD and its
   submodule commits instead. The command writes the entry into
   `verify/manifest.json` with the address it was proven at, and re-renders
   `verify/8453.md` and that chain's row in `verify/README.md`. A redeploy at a
   new address is detected from that recorded address and the entry is
   regenerated. Without `--chain`, it handles every chain with a contract that
   has no entry or a stale one.
4. Commit the address change and the generated `verify/` files in one PR. CI
   proves the changed chain again.

If no candidate proves, the command lists the contract with every candidate it
tried and writes nothing for it. If a PR leaves a contract without an entry,
or with an entry proven at another address, the completeness check fails and
names the command to run.

## Adding a chain

`chains.js` is the source of `EulerChains.json`. Edit it, run `node chains.js`
and commit both files. CI regenerates `EulerChains.json` and fails on any
difference, then validates every chain. To run the same checks locally:

```bash
npm ci
node chains.js
npm test
npm run validate
```

### Chain fields

| Field | Value |
|-------|-------|
| `chainId` | EVM chain ID. |
| `name` | Short chain name. |
| `status` | `staging`, `production`, `unlisted` or `deprecated` (see below). Required. |
| `explorerUrl` | The chain's canonical block explorer: an https origin with no trailing slash, such as `https://etherscan.io`. Apps link `${explorerUrl}/address/<address>` and `${explorerUrl}/tx/<hash>`. Required. |
| `verifier` | How to verify a contract's source so `explorerUrl` shows it, as `{ "type": …, "url": … }` with evk-periphery's verifier names: `etherscan` (Etherscan V2; no `url`), `blockscout` (`url` is its API, as forge's `--verifier-url` takes it, such as `https://explorer.tac.build/api`), `sourcify` (`url` only for a server other than sourcify.dev) or `custom` (an Etherscan-compatible API such as Routescan; `url` required). URLs are canonical https with no trailing slash. Required. The Toolbox reads it; deployment scripts keep their `--verifier` flag, because a new chain's contracts are verified before it has an entry here. |
| `viemName` | The chain's export name in `viem/chains`, such as `base`. It must name a viem chain with this chain ID. Required when viem exports more than one chain with the ID; without it, viem must export exactly one. CI checks this against the viem version pinned in `package.json`. |
| `safeBaseUrl` | The Safe{Wallet} app that serves the chain. |
| `safeAddressPrefix` | Safe's short name for the chain, as in `eth:0x…`. |

`addresses` is generated from the address files; do not edit it by hand.

### Status

| Status | In the apps |
|--------|-------------|
| `staging` | Shown in staging and preview deployments only, each app per its own runbook. A new chain starts here. |
| `production` | Shown everywhere. |
| `unlisted` | Hidden in the apps, but still indexed and checked. |
| `deprecated` | Shown with a deprecated badge, so users can exit. For chains Euler is leaving. |

The former status `testing` is retired; CI rejects it. Most apps read the
latest `EulerChains.json` at runtime, so a merged change to `status` or
`explorerUrl` reaches them without an app release. The Toolbox reads a
pinned registry commit instead and picks up the change only once a Toolbox PR
moves its pin.

### Steps

1. **Chain entry.** Add the chain to `chains.js` with `status: 'staging'`, its
   `explorerUrl`, its `verifier` and, if needed, `viemName`. Run
   `node chains.js`. euler-verifier reads the chain's name, explorer and
   verifier from `EulerChains.json`, and its RPC endpoints from viem, so it
   needs no change of its own.
2. **Address files.** Deploy. The deployment writes
   `addresses/<chainId>/<Group>Addresses.json` for each group (`Core`,
   `Periphery`, `Lens`, `Governor`, `Multisig`, `Token`, `Bridge`,
   `EulerSwap`). `chains.js` publishes each file under `addresses`, for
   example `CoreAddresses.json` as `addresses.coreAddrs`.
3. **`config/`.**
   - `config/addresses/<chainId>/*Addresses.json` files are merged into the
     same groups as `addresses/<chainId>/`.
   - `config/multisig/<name>.json` holds the expected `threshold` and
     `signers` of each named multisig.
   - `config/bridge/BridgeConfigCache.json` lists, per token and source chain,
     the chains it is bridged to. evk-periphery's option 50 writes it: commit
     the version it wrote, including the Ethereum run's row. Never edit it by
     hand, because option 50 treats a pair already listed as configured and
     skips that pair's bridge setup.
4. **Verify manifest and report.** Generate every manifest entry and the
   chain's report from a euler-verifier checkout, as in
   [Adding or redeploying a contract](#adding-or-redeploying-a-contract):

   ```bash
   pnpm add-entries --interfaces ../euler-interfaces --chain <chainId> \
     --candidates-from ../evk-periphery
   ```

   It writes the entries into `verify/manifest.json`, `verify/<chainId>.md`
   and the chain's row in `verify/README.md`.
5. **One PR.** Open a single PR with the address files, `config/` changes,
   `chains.js`, `EulerChains.json` and the generated `verify/` files. CI
   validates the chain entry and proves the chain's bytecode.
6. **Launch.** Set `status: 'production'` once each app's runbook for the
   chain is done.

euler-verifier takes the chain's name and RPC endpoints from viem. If viem's
default RPC for the chain is unusable, set `DEPLOYMENT_RPC_URL_<chainId>` for
the local run; CI then needs a euler-verifier viem bump and this repo's CI pin
(`.github/workflows/deployed-code-verification.yml`) moved to that commit. If
`npm run validate` here doesn't know the chain, bump `viem` in this repo's
`package.json` as well.

### Retiring a chain

1. Set `status: 'deprecated'` while users exit.
2. If EUL was bridged to the chain, remove its peer on Ethereum while
   `addresses/<chainId>/` still exists: add the chain to
   `configIgnoreChainIds` in evk-periphery's `script/50_CoreAndPeriphery.s.sol`,
   then run option 50 on Ethereum as a DAO Safe batch. The script only reads
   chains under `addresses/<chainId>/`.
3. Once the chain is no longer offered, remove it from `chains.js`, then:
   - **A chain that was live:** move `addresses/<chainId>/` to
     `addresses/test/<chainId>/`, merging in any `config/addresses/<chainId>/`
     values. Remove its `verify/manifest.json` entries and its
     `verify/<chainId>.md` report, and re-render the reports
     (`pnpm add-entries --interfaces ../euler-interfaces --render` in
     euler-verifier) so its row leaves `verify/README.md`. Only the addresses
     stay, as the record:
     `addresses/test/` is not published in `EulerChains.json` and not
     bytecode-verified.
   - **A chain that never went live:** remove it entirely, addresses included.

## Security

See [SECURITY.md](SECURITY.md) for the disclosure policy, and the
[verification reports](verify/README.md) for what is deployed where.
