// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerEarnVaultLens {
    struct AssetPriceInfo {
        bool queryFailure;
        bytes queryFailureReason;
        uint256 timestamp;
        address oracle;
        address asset;
        address unitOfAccount;
        uint256 amountIn;
        uint256 amountOutMid;
        uint256 amountOutBid;
        uint256 amountOutAsk;
    }

    struct EulerEarnVaultAccessControlInfo {
        address[] defaultAdmins;
        address[] guardianAdmins;
        address[] strategyOperatorAdmins;
        address[] eulerEarnManagerAdmins;
        address[] withdrawalQueueManagerAdmins;
        address[] rebalancerAdmins;
        address[] guardians;
        address[] strategyOperators;
        address[] eulerEarnManagers;
        address[] withdrawalQueueManagers;
        address[] rebalancers;
    }

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
        uint256 totalAssetsDeposited;
        uint256 totalAssetsAllocated;
        uint256 totalAssetsAllocatable;
        uint256 totalAllocationPoints;
        uint256 interestAccrued;
        uint256 lastInterestUpdate;
        uint256 interestSmearEnd;
        uint256 interestLeft;
        uint256 lastHarvestTimestamp;
        uint256 interestSmearingPeriod;
        uint256 performanceFee;
        address feeReceiver;
        uint256 hookedOperations;
        address hookTarget;
        address evc;
        address balanceTracker;
        address permit2;
        bool isHarvestCoolDownCheckOn;
        EulerEarnVaultAccessControlInfo accessControlInfo;
        EulerEarnVaultStrategyInfo[] strategies;
        AssetPriceInfo backupAssetPriceInfo;
        OracleDetailedInfo backupAssetOracleInfo;
    }

    struct EulerEarnVaultStrategyInfo {
        address strategy;
        uint256 assetsAllocated;
        uint256 allocationPoints;
        uint256 allocationCap;
        bool isInEmergency;
        VaultInfoERC4626 info;
    }

    struct OracleDetailedInfo {
        address oracle;
        string name;
        bytes oracleInfo;
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
    function getVaultAccessControlInfo(address vault) external view returns (EulerEarnVaultAccessControlInfo memory);
    function getVaultInfoFull(address vault) external view returns (EulerEarnVaultInfoFull memory);
    function oracleLens() external view returns (address);
    function utilsLens() external view returns (address);
}
