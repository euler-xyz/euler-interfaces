// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultLens {
    type InterestRateModelType is uint8;

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

    struct InterestRateInfo {
        uint256 cash;
        uint256 borrows;
        uint256 borrowSPY;
        uint256 borrowAPY;
        uint256 supplyAPY;
    }

    struct InterestRateModelDetailedInfo {
        address interestRateModel;
        InterestRateModelType interestRateModelType;
        bytes interestRateModelParams;
    }

    struct LTVInfo {
        address collateral;
        uint256 borrowLTV;
        uint256 liquidationLTV;
        uint256 initialLiquidationLTV;
        uint256 targetTimestamp;
        uint256 rampDuration;
    }

    struct OracleDetailedInfo {
        address oracle;
        string name;
        bytes oracleInfo;
    }

    struct RewardAmountInfo {
        uint256 epoch;
        uint256 epochStart;
        uint256 epochEnd;
        uint256 rewardAmount;
    }

    struct VaultInfoDynamic {
        uint256 timestamp;
        address vault;
        uint256 totalShares;
        uint256 totalCash;
        uint256 totalBorrowed;
        uint256 totalAssets;
        uint256 accumulatedFeesShares;
        uint256 accumulatedFeesAssets;
        address governorFeeReceiver;
        address protocolFeeReceiver;
        uint256 protocolFeeShare;
        uint256 interestFee;
        uint256 hookedOperations;
        uint256 configFlags;
        uint256 supplyCap;
        uint256 borrowCap;
        uint256 maxLiquidationDiscount;
        uint256 liquidationCoolOffTime;
        address interestRateModel;
        address hookTarget;
        address governorAdmin;
        VaultInterestRateModelInfo irmInfo;
        LTVInfo[] collateralLTVInfo;
        AssetPriceInfo liabilityPriceInfo;
        AssetPriceInfo[] collateralPriceInfo;
        OracleDetailedInfo oracleInfo;
        AssetPriceInfo backupAssetPriceInfo;
        OracleDetailedInfo backupAssetOracleInfo;
    }

    struct VaultInfoFull {
        uint256 timestamp;
        address vault;
        string vaultName;
        string vaultSymbol;
        uint256 vaultDecimals;
        address asset;
        string assetName;
        string assetSymbol;
        uint256 assetDecimals;
        address unitOfAccount;
        string unitOfAccountName;
        string unitOfAccountSymbol;
        uint256 unitOfAccountDecimals;
        uint256 totalShares;
        uint256 totalCash;
        uint256 totalBorrowed;
        uint256 totalAssets;
        uint256 accumulatedFeesShares;
        uint256 accumulatedFeesAssets;
        address governorFeeReceiver;
        address protocolFeeReceiver;
        uint256 protocolFeeShare;
        uint256 interestFee;
        uint256 hookedOperations;
        uint256 configFlags;
        uint256 supplyCap;
        uint256 borrowCap;
        uint256 maxLiquidationDiscount;
        uint256 liquidationCoolOffTime;
        address dToken;
        address oracle;
        address interestRateModel;
        address hookTarget;
        address evc;
        address protocolConfig;
        address balanceTracker;
        address permit2;
        address creator;
        address governorAdmin;
        VaultInterestRateModelInfo irmInfo;
        LTVInfo[] collateralLTVInfo;
        AssetPriceInfo liabilityPriceInfo;
        AssetPriceInfo[] collateralPriceInfo;
        OracleDetailedInfo oracleInfo;
        AssetPriceInfo backupAssetPriceInfo;
        OracleDetailedInfo backupAssetOracleInfo;
    }

    struct VaultInfoStatic {
        uint256 timestamp;
        address vault;
        string vaultName;
        string vaultSymbol;
        uint256 vaultDecimals;
        address asset;
        string assetName;
        string assetSymbol;
        uint256 assetDecimals;
        address unitOfAccount;
        string unitOfAccountName;
        string unitOfAccountSymbol;
        uint256 unitOfAccountDecimals;
        address dToken;
        address oracle;
        address evc;
        address protocolConfig;
        address balanceTracker;
        address permit2;
        address creator;
    }

    struct VaultInterestRateModelInfo {
        bool queryFailure;
        bytes queryFailureReason;
        address vault;
        address interestRateModel;
        InterestRateInfo[] interestRateInfo;
        InterestRateModelDetailedInfo interestRateModelInfo;
    }

    struct VaultRewardInfo {
        uint256 timestamp;
        address vault;
        address reward;
        string rewardName;
        string rewardSymbol;
        uint8 rewardDecimals;
        address balanceTracker;
        uint256 epochDuration;
        uint256 currentEpoch;
        uint256 totalRewardedEligible;
        uint256 totalRewardRegistered;
        uint256 totalRewardClaimed;
        RewardAmountInfo[] epochInfoPrevious;
        RewardAmountInfo[] epochInfoUpcoming;
    }

    function TTL_ERROR() external view returns (int256);
    function TTL_INFINITY() external view returns (int256);
    function TTL_LIQUIDATION() external view returns (int256);
    function TTL_MORE_THAN_ONE_YEAR() external view returns (int256);
    function getRecognizedCollateralsLTVInfo(address vault) external view returns (LTVInfo[] memory);
    function getRewardVaultInfo(address vault, address reward, uint256 numberOfEpochs)
        external
        view
        returns (VaultRewardInfo memory);
    function getVaultInfoDynamic(address vault) external view returns (VaultInfoDynamic memory);
    function getVaultInfoFull(address vault) external view returns (VaultInfoFull memory);
    function getVaultInfoStatic(address vault) external view returns (VaultInfoStatic memory);
    function getVaultInterestRateModelInfo(address vault, uint256[] memory cash, uint256[] memory borrows)
        external
        view
        returns (VaultInterestRateModelInfo memory);
    function getVaultKinkInterestRateModelInfo(address vault)
        external
        view
        returns (VaultInterestRateModelInfo memory);
    function irmLens() external view returns (address);
    function oracleLens() external view returns (address);
    function utilsLens() external view returns (address);
}
