// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library IEulerSwap {
    struct InitialState {
        uint112 currReserve0;
        uint112 currReserve1;
    }

    struct Params {
        address vault0;
        address vault1;
        address eulerAccount;
        uint112 equilibriumReserve0;
        uint112 equilibriumReserve1;
        uint256 priceX;
        uint256 priceY;
        uint256 concentrationX;
        uint256 concentrationY;
        uint256 fee;
        uint256 protocolFee;
        address protocolFeeRecipient;
    }
}

interface IEulerSwapFactory {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error E_DeploymentFailed();
    error InvalidFee();
    error InvalidProtocolFee();
    error InvalidQuery();
    error InvalidVaultImplementation();
    error NotAuthorized();
    error OldOperatorStillInstalled();
    error OperatorNotInstalled();
    error RecipientSetAlready();
    error SliceOutOfBounds();
    error Unauthorized();

    event OwnershipTransferred(address indexed user, address indexed newOwner);
    event PoolConfig(address indexed pool, IEulerSwap.Params params, IEulerSwap.InitialState initialState);
    event PoolDeployed(address indexed asset0, address indexed asset1, address indexed eulerAccount, address pool);
    event PoolUninstalled(address indexed asset0, address indexed asset1, address indexed eulerAccount, address pool);
    event ProtocolFeeRecipientSet(address protocolFeeRecipient);
    event ProtocolFeeSet(uint256 protocolFee);

    function EVC() external view returns (address);
    function MAX_PROTOCOL_FEE() external view returns (uint256);
    function MIN_PROTOCOL_FEE() external view returns (uint256);
    function computePoolAddress(IEulerSwap.Params memory poolParams, bytes32 salt) external view returns (address);
    function deployPool(IEulerSwap.Params memory params, IEulerSwap.InitialState memory initialState, bytes32 salt)
        external
        returns (address);
    function deploymentTimestamp() external view returns (uint256);
    function enableProtocolFee() external;
    function eulerSwapImpl() external view returns (address);
    function evkFactory() external view returns (address);
    function owner() external view returns (address);
    function poolByEulerAccount(address eulerAccount) external view returns (address);
    function pools() external view returns (address[] memory);
    function poolsByPair(address asset0, address asset1) external view returns (address[] memory);
    function poolsByPairLength(address asset0, address asset1) external view returns (uint256);
    function poolsByPairSlice(address asset0, address asset1, uint256 start, uint256 end)
        external
        view
        returns (address[] memory);
    function poolsLength() external view returns (uint256);
    function poolsSlice(uint256 start, uint256 end) external view returns (address[] memory);
    function protocolFee() external view returns (uint256);
    function protocolFeeRecipient() external view returns (address);
    function recipientSetter() external view returns (address);
    function setProtocolFee(uint256 newFee) external;
    function setProtocolFeeRecipient(address newRecipient) external;
    function transferOwnership(address newOwner) external;
    function uninstallPool() external;
}
