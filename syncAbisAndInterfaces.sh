#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <evk_periphery_repo_path> <network_id>"
  exit 1
fi

evk_periphery_repo_path=$1
network_id=$2
abis_path="./abis/${network_id}"
interfaces_path="./interfaces/${network_id}"
addresses_path="./addresses/${network_id}"

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
  "IRMLinearKink"
  "EulerRouter"
  "TermsOfUseSigner"
)

for contract in "${contracts[@]}"; do
  jq '.abi' $evk_periphery_repo_path/out/${contract}.sol/${contract}.json | jq '.' > $abis_path/${contract}.json
  
  cast interface --name I${contract} --pragma ^0.8.0 -o $interfaces_path/I${contract}.sol $abis_path/${contract}.json
  sed -i '' 's/\/\/ SPDX-License-Identifier: UNLICENSED/\/\/ SPDX-License-Identifier: MIT/' "$interfaces_path/I${contract}.sol"
done
  
for file in $addresses_path/*.json; do
  while IFS= read -r line; do
    key=$(echo "$line" | jq -r '.key')
    value=$(echo "$line" | jq -r '.value')
    checksummed_value=$(cast to-check-sum-address "$value")
    jq --arg key "$key" --arg value "$checksummed_value" '.[$key] = $value' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  done < <(jq -c 'to_entries[]' "$file")

  solidityFile=$(basename "$file" .json)

  echo "// SPDX-License-Identifier: MIT" > $addresses_path/$solidityFile.sol
  echo "pragma solidity ^0.8.0;" >> $addresses_path/$solidityFile.sol
  echo "" >> $addresses_path/$solidityFile.sol
  echo "library $solidityFile {" >> $addresses_path/$solidityFile.sol

  jq -r 'to_entries[] | "    address public constant \(.key) = \(.value);"' "$file" >> $addresses_path/$solidityFile.sol

  echo "}" >> $addresses_path/$solidityFile.sol
done
