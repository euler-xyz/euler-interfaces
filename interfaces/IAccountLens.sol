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
        address account;
        address vault;
        address unitOfAccount;
        int256 timeToLiquidation;
        uint256 liabilityValueBorrowing;
        uint256 liabilityValueLiquidation;
        uint256 collateralValueBorrowing;
        uint256 collateralValueLiquidation;
        uint256 collateralValueRaw;
        address[] collaterals;
        uint256[] collateralValuesBorrowing;
        uint256[] collateralValuesLiquidation;
        uint256[] collateralValuesRaw;
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
    function getAccountLiquidityInfo(address account, address vault)
        external
        view
        returns (AccountLiquidityInfo memory);
    function getAccountLiquidityInfoNoValidation(address account, address vault)
        external
        view
        returns (AccountLiquidityInfo memory);
    function getEVCAccountInfo(address evc, address account) external view returns (EVCAccountInfo memory);
    function getRewardAccountInfo(address account, address vault) external view returns (AccountRewardInfo memory);
    function getTimeToLiquidation(address account, address vault) external view returns (int256);
    function getVaultAccountInfo(address account, address vault) external view returns (VaultAccountInfo memory);
}
