// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerEarnVaultLens {
    struct EulerEarnVaultInfoFull {
        uint256 timestamp;
        address vault;
        string vaultName;
        string vaultSymbol;
        uint256 vaultDecimals;
        address asset;
        string assetName;
        string assetSymbol;
        uint256 assetDecimals;
        uint256 totalShares;
        uint256 totalAssets;
        uint256 lostAssets;
        uint256 performanceFee;
        address feeReceiver;
        address skimRecipient;
        address creator;
        address curator;
        address guardian;
        address evc;
        address permit2;
        EulerEarnVaultStrategyInfo[] strategies;
    }

    struct EulerEarnVaultStrategyInfo {
        address strategy;
        uint256 assetsAllocated;
        uint256 currentAllocationCap;
        uint256 pendingAllocationCap;
        uint256 pendingAllocationCapValidAt;
        uint256 removableAt;
        bool enabled;
        VaultInfoERC4626 info;
    }

    struct VaultInfoERC4626 {
        uint256 timestamp;
        address vault;
        string vaultName;
        string vaultSymbol;
        uint256 vaultDecimals;
        address asset;
        string assetName;
        string assetSymbol;
        uint256 assetDecimals;
        uint256 totalShares;
        uint256 totalAssets;
        bool isEVault;
    }

    function TTL_ERROR() external view returns (int256);
    function TTL_INFINITY() external view returns (int256);
    function TTL_LIQUIDATION() external view returns (int256);
    function TTL_MORE_THAN_ONE_YEAR() external view returns (int256);
    function getVaultInfoFull(address vault) external view returns (EulerEarnVaultInfoFull memory);
    function utilsLens() external view returns (address);
}
