// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library IEulerSwap {
    struct DynamicParams {
        uint112 equilibriumReserve0;
        uint112 equilibriumReserve1;
        uint112 minReserve0;
        uint112 minReserve1;
        uint80 priceX;
        uint80 priceY;
        uint64 concentrationX;
        uint64 concentrationY;
        uint64 fee0;
        uint64 fee1;
        uint40 expiration;
        uint8 swapHookedOperations;
        address swapHook;
    }

    struct InitialState {
        uint112 reserve0;
        uint112 reserve1;
    }

    struct StaticParams {
        address supplyVault0;
        address supplyVault1;
        address borrowVault0;
        address borrowVault1;
        address eulerAccount;
        address feeRecipient;
    }
}

interface IEulerSwapFactory {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error E_DeploymentFailed();
    error NotAuthorized();
    error OperatorNotInstalled();
    error Unauthorized();

    event PoolDeployed(
        address indexed asset0,
        address indexed asset1,
        address indexed eulerAccount,
        address pool,
        IEulerSwap.StaticParams sParams
    );

    function EVC() external view returns (address);
    function computePoolAddress(IEulerSwap.StaticParams memory sParams, bytes32 salt) external view returns (address);
    function creationCode(IEulerSwap.StaticParams memory sParams) external view returns (bytes memory);
    function deployPool(
        IEulerSwap.StaticParams memory sParams,
        IEulerSwap.DynamicParams memory dParams,
        IEulerSwap.InitialState memory initialState,
        bytes32 salt
    ) external returns (address);
    function deployedPools(address pool) external view returns (bool);
    function eulerSwapImpl() external view returns (address);
}
