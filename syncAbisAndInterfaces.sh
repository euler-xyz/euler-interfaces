#!/bin/bash

if [ -z "$1" || -z "$2" ]; then
  echo "Usage: $0 <evk_periphery_repo_path> <network_id>"
  exit 1
fi

evk_periphery_repo_path=$1
network_id=$2
abis_path="./abis/${network_id}"
interfaces_path="./interfaces/${network_id}"

mkdir -p $abis_path $interfaces_path

# Copy abis and generate interfaces
contracts=("EthereumVaultConnector" "BaseRewardStreams" "GenericFactory" "EulerRouterFactory" "EulerRouter" "SwapVerifier" "BasePerspective" "AccountLens" "OracleLens" "VaultLens" "UtilsLens")
interfaces=("IEVault" "IEulerKinkIRMFactory" "ISwapper")

for contract in "${contracts[@]}"; do
  jq -c '.abi' $evk_periphery_repo_path/out/${contract}.sol/${contract}.json > $abis_path/${contract}.json
  cast interface --name I${contract} --pragma ^0.8.0 -o $interfaces_path/I${contract}.sol $abis_path/${contract}.json
done

for interface in "${interface[@]}"; do
  jq -c '.abi' $evk_periphery_repo_path/out/${interface}.sol/${interface}.json > $abis_path/${interface}.json
  cast interface --name ${interface} --pragma ^0.8.0 -o $interfaces_path/${interface}.sol $abis_path/${interface}.json
done
