// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRewardToken {
    error ControllerDisabled();
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC20InvalidUnderlying(address token);
    error EVC_InvalidAddress();
    error EnumerableMapNonexistentKey(bytes32 key);
    error InvalidWhitelistStatus();
    error NotAuthorized();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error RemainderLossNotAllowed();
    error SafeERC20FailedOperation(address token);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event LockCreated(address indexed account, uint256 lockTimestamp);
    event LockRemoved(address indexed account, uint256 lockTimestamp);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event RemainderReceiverSet(address indexed remainderReceiver);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event WhitelistStatusSet(address indexed account, uint256 status);

    function EVC() external view returns (address);
    function WHITELIST_STATUS_ADMIN() external view returns (uint256);
    function WHITELIST_STATUS_DISTRIBUTOR() external view returns (uint256);
    function WHITELIST_STATUS_NONE() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function depositFor(address account, uint256 amount) external returns (bool);
    function getLockedAmountByLockTimestamp(address account, uint256 lockTimestamp) external view returns (uint256);
    function getLockedAmounts(address account) external view returns (uint256[] memory, uint256[] memory);
    function getLockedAmountsLength(address account) external view returns (uint256);
    function getLockedAmountsLockTimestamps(address account) external view returns (uint256[] memory);
    function getWithdrawAmountsByLockTimestamp(address account, uint256 lockTimestamp)
        external
        view
        returns (uint256, uint256);
    function name() external view returns (string memory);
    function owner() external view returns (address);
    function remainderReceiver() external view returns (address);
    function renounceOwnership() external pure;
    function setRemainderReceiver(address _remainderReceiver) external;
    function setWhitelistStatus(address account, uint256 status) external;
    function setWhitelistStatus(uint256 status) external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transferOwnership(address newOwner) external;
    function underlying() external view returns (address);
    function whitelistStatus(address) external view returns (uint256);
    function withdrawTo(address account, uint256 amount) external returns (bool);
    function withdrawToByLockTimestamp(address account, uint256 lockTimestamp, bool allowRemainderLoss)
        external
        returns (bool);
    function withdrawToByLockTimestamps(address account, uint256[] memory lockTimestamps, bool allowRemainderLoss)
        external
        returns (bool);
}
