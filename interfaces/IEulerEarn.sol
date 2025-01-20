// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Checkpoints {
    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }
}

library Shared {
    struct IntegrationsParams {
        address evc;
        address balanceTracker;
        address permit2;
        bool isHarvestCoolDownCheckOn;
    }
}

interface IEulerEarn {
    type StrategyStatus is uint8;
    type AmountCap is uint16;

    struct DeploymentParams {
        address eulerEarnVaultModule;
        address rewardsModule;
        address hooksModule;
        address feeModule;
        address strategyModule;
        address withdrawalQueueModule;
    }

    struct InitParams {
        address eulerEarnVaultOwner;
        address asset;
        string name;
        string symbol;
        uint256 initialCashAllocationPoints;
        uint24 smearingPeriod;
    }

    struct Strategy {
        uint120 allocated;
        uint96 allocationPoints;
        AmountCap cap;
        StrategyStatus status;
    }

    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);
    error CheckpointUnorderedInsertion();
    error ControllerDisabled();
    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);
    error ERC20ExceededSafeSupply(uint256 increasedSupply, uint256 cap);
    error ERC20ExceededSafeSupply(uint256 increasedSupply, uint256 cap);
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC4626ExceededMaxDeposit(address receiver, uint256 assets, uint256 max);
    error ERC4626ExceededMaxMint(address receiver, uint256 shares, uint256 max);
    error ERC4626ExceededMaxRedeem(address owner, uint256 shares, uint256 max);
    error ERC4626ExceededMaxWithdraw(address owner, uint256 assets, uint256 max);
    error ERC5805FutureLookup(uint256 timepoint, uint48 clock);
    error ERC6372InconsistentClock();
    error EVC_InvalidAddress();
    error InitialAllocationPointsZero();
    error InvalidAccountNonce(address account, uint256 currentNonce);
    error InvalidAssetAddress();
    error InvalidInitialization();
    error InvalidSmearingPeriod();
    error NotAuthorized();
    error NotInitializing();
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);
    error ViewReentrancy();
    error VotesExpiredSignature(uint256 expiry);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousVotes, uint256 newVotes);
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
    event EIP712DomainChanged();
    event Initialized(uint64 version);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    function CLOCK_MODE() external view returns (string memory);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function EVC() external view returns (address);
    function addStrategy(address _strategy, uint256 _allocationPoints) external;
    function adjustAllocationPoints(address _strategy, uint256 _newPoints) external;
    function allowance(address _owner, address _spender) external view returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool);
    function asset() external view returns (address);
    function balanceForwarderEnabled(address _account) external view returns (bool);
    function balanceOf(address _account) external view returns (uint256);
    function balanceTrackerAddress() external view returns (address);
    function checkpoints(address _account, uint32 _pos) external view returns (Checkpoints.Checkpoint208 memory);
    function claimStrategyReward(address _strategy, address _reward, address _recipient, bool _forfeitRecentReward)
        external;
    function clock() external view returns (uint48);
    function convertToAssets(uint256 _shares) external view returns (uint256);
    function convertToShares(uint256 _assets) external view returns (uint256);
    function decimals() external view returns (uint8);
    function delegate(address _delegatee) external;
    function delegateBySig(address _delegatee, uint256 _nonce, uint256 _expiry, uint8 _v, bytes32 _r, bytes32 _s)
        external;
    function delegates(address _account) external view returns (address);
    function deposit(uint256 _assets, address _receiver) external returns (uint256);
    function disableBalanceForwarder() external;
    function disableRewardForStrategy(address _strategy, address _reward, bool _forfeitRecentReward) external;
    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        );
    function enableBalanceForwarder() external;
    function enableRewardForStrategy(address _strategy, address _reward) external;
    function eulerEarnVaultModule() external view returns (address);
    function feeModule() external view returns (address);
    function getEulerEarnSavingRate() external view returns (uint40, uint40, uint168);
    function getHooksConfig() external view returns (address, uint32);
    function getPastTotalSupply(uint256 _timepoint) external view returns (uint256);
    function getPastVotes(address _account, uint256 _timepoint) external view returns (uint256);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function getRoleMember(bytes32 role, uint256 index) external view returns (address);
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
    function getRoleMembers(bytes32 role) external view returns (address[] memory);
    function getStrategy(address _strategy) external view returns (Strategy memory);
    function getVotes(address _account) external view returns (uint256);
    function grantRole(bytes32 _role, address _account) external;
    function gulp() external;
    function harvest() external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function hooksModule() external view returns (address);
    function init(InitParams memory _initParams) external;
    function interestAccrued() external view returns (uint256);
    function interestSmearingPeriod() external view returns (uint256);
    function isCheckingHarvestCoolDown() external view returns (bool);
    function lastHarvestTimestamp() external view returns (uint256);
    function maxDeposit(address _owner) external view returns (uint256);
    function maxMint(address _owner) external view returns (uint256);
    function maxRedeem(address _owner) external view returns (uint256);
    function maxWithdraw(address _owner) external view returns (uint256);
    function mint(uint256 _shares, address _receiver) external returns (uint256);
    function name() external view returns (string memory);
    function nonces(address owner) external view returns (uint256);
    function numCheckpoints(address _account) external view returns (uint32);
    function optInStrategyRewards(address _strategy) external;
    function optOutStrategyRewards(address _strategy) external;
    function performanceFeeConfig() external view returns (address, uint96);
    function permit2Address() external view returns (address);
    function previewDeposit(uint256 _assets) external view returns (uint256);
    function previewMint(uint256 _shares) external view returns (uint256);
    function previewRedeem(uint256 _shares) external view returns (uint256);
    function previewWithdraw(uint256 _assets) external view returns (uint256);
    function rebalance(address[] memory _strategies) external;
    function redeem(uint256 _shares, address _receiver, address _owner) external returns (uint256 assets);
    function removeStrategy(address _strategy) external;
    function renounceRole(bytes32 _role, address _callerConfirmation) external;
    function reorderWithdrawalQueue(uint8 _index1, uint8 _index2) external;
    function revokeRole(bytes32 _role, address _account) external;
    function rewardsModule() external view returns (address);
    function setFeeRecipient(address _newFeeRecipient) external;
    function setHooksConfig(address _hooksTarget, uint32 _hookedFns) external;
    function setPerformanceFee(uint96 _newFee) external;
    function setStrategyCap(address _strategy, uint16 _cap) external;
    function skim(address _token, address _recipient) external;
    function strategyModule() external view returns (address);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function toggleStrategyEmergencyStatus(address _strategy) external;
    function totalAllocated() external view returns (uint256);
    function totalAllocationPoints() external view returns (uint256);
    function totalAssets() external view returns (uint256);
    function totalAssetsAllocatable() external view returns (uint256);
    function totalAssetsDeposited() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function updateInterestAccrued() external;
    function withdraw(uint256 _assets, address _receiver, address _owner) external returns (uint256 shares);
    function withdrawalQueue() external view returns (address[] memory);
    function withdrawalQueueModule() external view returns (address);
}
