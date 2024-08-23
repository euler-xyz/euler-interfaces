#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <evk_periphery_repo_path> [deployment_name network_id]"
  exit 1
fi

if [ ! -z "$2" ] && [ -z "$3" ] || [ -z "$2" ] && [ ! -z "$3" ]; then
  echo "Error: deployment_name and network_id must be provided together"
  exit 1
fi

evk_periphery_repo_path=$1
deployment_name=$2
network_id=$3
addresses_dir_path="$evk_periphery_repo_path/script/deployments/$deployment_name/output/"

mkdir -p "./abis" "./interfaces"

# Copy abis and generate interfaces
contracts=("EthereumVaultConnector" "BaseRewardStreams" "GenericFactory" "EulerRouterFactory" "EulerRouter" "SwapVerifier" "BasePerspective" "AccountLens" "OracleLens" "VaultLens" "UtilsLens")
interfaces=("IEVault" "IEulerKinkIRMFactory" "ISwapper")

for contract in "${contracts[@]}"; do
  jq -c '.abi' $evk_periphery_repo_path/out/${contract}.sol/${contract}.json > ./abis/${contract}.json
  cast interface --name I${contract} --pragma ^0.8.0 -o ./interfaces/I${contract}.sol ./abis/${contract}.json
done

for interface in "${interface[@]}"; do
  jq -c '.abi' $evk_periphery_repo_path/out/${interface}.sol/${interface}.json > ./abis/${interface}.json
  cast interface --name ${interface} --pragma ^0.8.0 -o ./interfaces/${interface}.sol ./abis/${interface}.json
done

# Copy addresses
if [[ $deployment_name != "" ]]; then
  mkdir -p "./addresses/$network_id"
  cp "$addresses_dir_path/CoreAddresses.json" "./addresses/$network_id/CoreAddresses.json"
  cp "$addresses_dir_path/PeripheryAddresses.json" "./addresses/$network_id/PeripheryAddresses.json"
  cp "$addresses_dir_path/LensAddresses.json" "./addresses/$network_id/LensAddresses.json"
fi