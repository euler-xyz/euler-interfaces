// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerSwapProtocolFeeConfig {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error InvalidAdminAddress();
    error InvalidProtocolFee();
    error InvalidProtocolFeeRecipient();
    error NotAuthorized();
    error Unauthorized();

    event AdminUpdated(address indexed oldAdmin, address indexed newAdmin);
    event DefaultUpdated(address indexed oldRecipient, address indexed newRecipient, uint64 oldFee, uint64 newFee);
    event OverrideRemoved(address indexed pool);
    event OverrideSet(address indexed pool, address indexed recipient, uint64 fee);

    function EVC() external view returns (address);
    function MAX_PROTOCOL_FEE() external view returns (uint64);
    function admin() external view returns (address);
    function defaultFee() external view returns (uint64);
    function defaultRecipient() external view returns (address);
    function getProtocolFee(address pool) external view returns (address recipient, uint64 fee);
    function overrides(address pool) external view returns (bool exists, address recipient, uint64 fee);
    function removeOverride(address pool) external;
    function setAdmin(address newAdmin) external;
    function setDefault(address recipient, uint64 fee) external;
    function setOverride(address pool, address recipient, uint64 fee) external;
}
