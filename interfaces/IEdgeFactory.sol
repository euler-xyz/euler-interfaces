// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEdgeFactory {
    struct AdapterParams {
        address base;
        address adapter;
    }

    struct DeployParams {
        VaultParams[] vaults;
        RouterParams router;
        LTVParams[] ltv;
        address unitOfAccount;
    }

    struct LTVParams {
        uint256 collateralVaultIndex;
        uint256 controllerVaultIndex;
        uint16 borrowLTV;
        uint16 liquidationLTV;
    }

    struct RouterParams {
        address[] externalResolvedVaults;
        AdapterParams[] adapters;
    }

    struct VaultParams {
        address asset;
        address irm;
        bool escrow;
    }

    error E_BadQuery();
    error E_TooFewVaults();

    event EdgeDeployed(address indexed router, address[] vaults);

    function deploy(DeployParams memory params) external returns (address, address[] memory);
    function eVaultFactory() external view returns (address);
    function escrowedCollateralPerspective() external view returns (address);
    function eulerRouterFactory() external view returns (address);
    function getDeployment(uint256 i) external view returns (address[] memory);
    function getDeploymentsListLength() external view returns (uint256);
    function getDeploymentsListSlice(uint256 start, uint256 end) external view returns (address[][] memory list);
    function isDeployed(address) external view returns (bool);
    function name() external view returns (string memory);
}
