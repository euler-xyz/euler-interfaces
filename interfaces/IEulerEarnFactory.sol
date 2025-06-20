// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerEarnFactory {
    error BadQuery();
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error NotAuthorized();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error ZeroAddress();

    event CreateEulerEarn(
        address indexed eulerEarn,
        address indexed caller,
        address initialOwner,
        uint256 initialTimelock,
        address indexed asset,
        string name,
        string symbol,
        bytes32 salt
    );
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SetPerspective(address);

    function EVC() external view returns (address);
    function createEulerEarn(
        address initialOwner,
        uint256 initialTimelock,
        address asset,
        string memory name,
        string memory symbol,
        bytes32 salt
    ) external returns (address eulerEarn);
    function getVaultListLength() external view returns (uint256);
    function getVaultListSlice(uint256 start, uint256 end) external view returns (address[] memory list);
    function isStrategyAllowed(address id) external view returns (bool);
    function isVault(address) external view returns (bool);
    function owner() external view returns (address);
    function permit2Address() external view returns (address);
    function renounceOwnership() external;
    function setPerspective(address _perspective) external;
    function supportedPerspective() external view returns (address);
    function transferOwnership(address newOwner) external;
    function vaultList(uint256) external view returns (address);
}
