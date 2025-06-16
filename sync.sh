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
  "SnapshotRegistry"
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
  "EdgeFactory"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
done

contracts=(
  "EulerEarn"
  "EulerEarnFactory"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out-euler-earn/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
done

contracts=(
  "EulerSwap"
  "EulerSwapFactory"
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
