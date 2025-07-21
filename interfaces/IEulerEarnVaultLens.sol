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
        uint256 availableAssets;
        uint256 timelock;
        uint256 performanceFee;
        address feeReceiver;
        address owner;
        address creator;
        address curator;
        address guardian;
        address evc;
        address permit2;
        uint256 pendingTimelock;
        uint256 pendingTimelockValidAt;
        address pendingGuardian;
        uint256 pendingGuardianValidAt;
        address[] supplyQueue;
        EulerEarnVaultStrategyInfo[] strategies;
    }

    struct EulerEarnVaultStrategyInfo {
        address strategy;
        uint256 allocatedAssets;
        uint256 availableAssets;
        uint256 currentAllocationCap;
        uint256 pendingAllocationCap;
        uint256 pendingAllocationCapValidAt;
        uint256 removableAt;
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
    function getStrategiesInfo(address vault, address[] memory strategies)
        external
        view
        returns (EulerEarnVaultStrategyInfo[] memory);
    function getStrategyInfo(address _vault, address _strategy)
        external
        view
        returns (EulerEarnVaultStrategyInfo memory);
    function getVaultInfoFull(address vault) external view returns (EulerEarnVaultInfoFull memory);
    function utilsLens() external view returns (address);
}
