// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISnapshotRegistry {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error NotAuthorized();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error Registry_AlreadyAdded();
    error Registry_AlreadyRevoked();
    error Registry_NotAdded();

    event Added(address indexed element, address indexed asset0, address indexed asset1, uint256 addedAt);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Revoked(address indexed element, uint256 revokedAt);

    function EVC() external view returns (address);
    function add(address element, address base, address quote) external;
    function entries(address) external view returns (uint128 addedAt, uint128 revokedAt);
    function getValidAddresses(address base, address quote, uint256 snapshotTime)
        external
        view
        returns (address[] memory);
    function isValid(address element, uint256 snapshotTime) external view returns (bool);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function revoke(address element) external;
    function transferOwnership(address newOwner) external;
}
