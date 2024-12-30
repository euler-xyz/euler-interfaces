// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITrackingRewardStreams {
    error AccumulatorOverflow();
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error InvalidAmount();
    error InvalidDistribution();
    error InvalidEpoch();
    error InvalidRecipient();
    error NotAuthorized();
    error ReentrancyGuardReentrantCall();
    error SafeERC20FailedOperation(address token);
    error TooManyElements();
    error TooManyRewardsEnabled();

    event BalanceUpdated(address indexed account, address indexed rewarded, uint256 oldBalance, uint256 newBalance);
    event RewardClaimed(address indexed account, address indexed rewarded, address indexed reward, uint256 amount);
    event RewardDisabled(address indexed account, address indexed rewarded, address indexed reward);
    event RewardEnabled(address indexed account, address indexed rewarded, address indexed reward);
    event RewardRegistered(
        address indexed caller, address indexed rewarded, address indexed reward, uint256 startEpoch, uint128[] amounts
    );

    function EPOCH_DURATION() external view returns (uint256);
    function EVC() external view returns (address);
    function MAX_DISTRIBUTION_LENGTH() external view returns (uint256);
    function MAX_EPOCHS_AHEAD() external view returns (uint256);
    function MAX_REWARDS_ENABLED() external view returns (uint256);
    function balanceOf(address account, address rewarded) external view returns (uint256);
    function balanceTrackerHook(address account, uint256 newAccountBalance, bool forfeitRecentReward) external;
    function claimReward(address rewarded, address reward, address recipient, bool ignoreRecentReward)
        external
        returns (uint256);
    function currentEpoch() external view returns (uint48);
    function disableReward(address rewarded, address reward, bool forfeitRecentReward) external returns (bool);
    function earnedReward(address account, address rewarded, address reward, bool ignoreRecentReward)
        external
        view
        returns (uint256);
    function enableReward(address rewarded, address reward) external returns (bool);
    function enabledRewards(address account, address rewarded) external view returns (address[] memory);
    function getEpoch(uint48 timestamp) external view returns (uint48);
    function getEpochEndTimestamp(uint48 epoch) external view returns (uint48);
    function getEpochStartTimestamp(uint48 epoch) external view returns (uint48);
    function isRewardEnabled(address account, address rewarded, address reward) external view returns (bool);
    function registerReward(address rewarded, address reward, uint48 startEpoch, uint128[] memory rewardAmounts)
        external;
    function rewardAmount(address rewarded, address reward) external view returns (uint256);
    function rewardAmount(address rewarded, address reward, uint48 epoch) external view returns (uint256);
    function totalRewardClaimed(address rewarded, address reward) external view returns (uint256);
    function totalRewardRegistered(address rewarded, address reward) external view returns (uint256);
    function totalRewardedEligible(address rewarded, address reward) external view returns (uint256);
    function updateReward(address rewarded, address reward, address recipient) external returns (uint256);
}
