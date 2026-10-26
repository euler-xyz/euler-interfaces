#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <evk_periphery_repo_path>"
  exit 1
fi

evk_periphery_repo_path=$1
abis_path="./abis"
interfaces_path="./interfaces"

mkdir -p $abis_path $interfaces_path
contracts=(
  "TrackingRewardStreams"
  "GenericFactory"
  "EVault"
  "EthereumVaultConnector"
  "ProtocolConfig"
  "SequenceRegistry"
  "BasePerspective"
  "EscrowedCollateralPerspective"
  "FeeFlowController"
  "EulerKinkIRMFactory"
  "EulerRouterFactory"
  "SwapVerifier"
  "Swapper"  
  "AccountLens"
  "IRMLens"
  "OracleLens"
  "VaultLens"
  "UtilsLens"
  "EulerEarnVaultLens"
  "IRMLinearKink"
  "EulerRouter"
  "TermsOfUseSigner"
  "RewardToken"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
done

# evk-periphery builds only the V2 Securitize contracts, whose ABI matches V1; consumers read the V1 file names.
contracts=(
  "ERC4626EVCCollateralSecuritizeV2:ERC4626EVCCollateralSecuritize"
  "ERC4626EVCCollateralSecuritizeFactoryV2:ERC4626EVCCollateralSecuritizeFactory"
)

for contract in "${contracts[@]}"; do
  source=${contract%%:*}
  target=${contract##*:}
  jq '.abi' $evk_periphery_repo_path/out-securitize-factory/${source}.sol/${source}.json | jq '.' > $abis_path/${target}.json
done

contracts=(
  "EulerEarn"
  "EulerEarnFactory"
  "PublicAllocator"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out-euler-earn/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
done

contracts=(
  "EulerSwap"
  "EulerSwapFactory"
  "EulerSwapRegistry"
  "EulerSwapProtocolFeeConfig"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out-euler-swap/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
done

for abi_file in "$abis_path"/*.json; do
  contract=$(basename "$abi_file" .json)
  cast interface --name I${contract} --pragma ^0.8.0 -o $interfaces_path/I${contract}.sol $abi_file
  sed -i '' 's/\/\/ SPDX-License-Identifier: UNLICENSED/\/\/ SPDX-License-Identifier: MIT/' "$interfaces_path/I${contract}.sol"
done


node chains.js
