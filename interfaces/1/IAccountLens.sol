// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAccountLens {
    struct AccountInfo {
        EVCAccountInfo evcAccountInfo;
        VaultAccountInfo vaultAccountInfo;
        AccountRewardInfo accountRewardInfo;
    }

    struct AccountLiquidityInfo {
        bool queryFailure;
        bytes queryFailureReason;
        int256 timeToLiquidation;
        uint256 liabilityValue;
        uint256 collateralValueBorrowing;
        uint256 collateralValueLiquidation;
        uint256 collateralValueRaw;
        CollateralLiquidityInfo[] collateralLiquidityBorrowingInfo;
        CollateralLiquidityInfo[] collateralLiquidityLiquidationInfo;
        CollateralLiquidityInfo[] collateralLiquidityRawInfo;
    }

    struct AccountMultipleVaultsInfo {
        EVCAccountInfo evcAccountInfo;
        VaultAccountInfo[] vaultAccountInfo;
        AccountRewardInfo[] accountRewardInfo;
    }

    struct AccountRewardInfo {
        uint256 timestamp;
        address account;
        address vault;
        address balanceTracker;
        bool balanceForwarderEnabled;
        uint256 balance;
        EnabledRewardInfo[] enabledRewardsInfo;
    }

    struct CollateralLiquidityInfo {
        address collateral;
        uint256 collateralValue;
    }

    struct EVCAccountInfo {
        uint256 timestamp;
        address evc;
        address account;
        bytes19 addressPrefix;
        address owner;
        bool isLockdownMode;
        bool isPermitDisabledMode;
        uint256 lastAccountStatusCheckTimestamp;
        address[] enabledControllers;
        address[] enabledCollaterals;
    }

    struct EnabledRewardInfo {
        address reward;
        uint256 earnedReward;
        uint256 earnedRewardRecentIgnored;
    }

    struct VaultAccountInfo {
        uint256 timestamp;
        address account;
        address vault;
        address asset;
        uint256 assetsAccount;
        uint256 shares;
        uint256 assets;
        uint256 borrowed;
        uint256 assetAllowanceVault;
        uint256 assetAllowanceVaultPermit2;
        uint256 assetAllowanceExpirationVaultPermit2;
        uint256 assetAllowancePermit2;
        bool balanceForwarderEnabled;
        bool isController;
        bool isCollateral;
        AccountLiquidityInfo liquidityInfo;
    }

    function TTL_ERROR() external view returns (int256);
    function TTL_INFINITY() external view returns (int256);
    function TTL_LIQUIDATION() external view returns (int256);
    function TTL_MORE_THAN_ONE_YEAR() external view returns (int256);
    function getAccountEnabledVaultsInfo(address evc, address account)
        external
        view
        returns (AccountMultipleVaultsInfo memory);
    function getAccountInfo(address account, address vault) external view returns (AccountInfo memory);
    function getEVCAccountInfo(address evc, address account) external view returns (EVCAccountInfo memory);
    function getRewardAccountInfo(address account, address vault) external view returns (AccountRewardInfo memory);
    function getTimeToLiquidation(address account, address vault) external view returns (int256);
    function getVaultAccountInfo(address account, address vault) external view returns (VaultAccountInfo memory);
}
