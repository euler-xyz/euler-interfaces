// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPublicAllocator {
    struct FlowCaps {
        uint128 maxIn;
        uint128 maxOut;
    }

    struct FlowCapsConfig {
        address id;
        FlowCaps caps;
    }

    struct Withdrawal {
        address id;
        uint128 amount;
    }

    error AlreadySet();
    error ControllerDisabled();
    error DepositMarketInWithdrawals();
    error EVC_InvalidAddress();
    error EmptyWithdrawals();
    error FeeTransferFailed(address feeRecipient);
    error InconsistentWithdrawals();
    error IncorrectFee();
    error MarketNotEnabled(address id);
    error MaxInflowExceeded(address id);
    error MaxOutflowExceeded(address id);
    error MaxSettableFlowCapExceeded();
    error NotAdminNorVaultOwner();
    error NotAuthorized();
    error NotEnoughSupply(address id);
    error WithdrawZero(address id);

    event PublicReallocateTo(
        address indexed sender, address indexed vault, address indexed supplyId, uint256 suppliedAssets
    );
    event PublicWithdrawal(address indexed sender, address indexed vault, address indexed id, uint256 withdrawnAssets);
    event SetAdmin(address indexed sender, address indexed vault, address admin);
    event SetAllocationFee(address indexed sender, address indexed vault, uint256 fee);
    event SetFlowCaps(address indexed sender, address indexed vault, FlowCapsConfig[] config);
    event TransferAllocationFee(
        address indexed sender, address indexed vault, uint256 amount, address indexed feeRecipient
    );

    function EVC() external view returns (address);
    function accruedFee(address) external view returns (uint256);
    function admin(address) external view returns (address);
    function fee(address) external view returns (uint256);
    function flowCaps(address, address) external view returns (uint128 maxIn, uint128 maxOut);
    function reallocateTo(address vault, Withdrawal[] memory withdrawals, address supplyId) external payable;
    function setAdmin(address vault, address newAdmin) external;
    function setFee(address vault, uint256 newFee) external;
    function setFlowCaps(address vault, FlowCapsConfig[] memory config) external;
    function transferFee(address vault, address payable feeRecipient) external;
}
