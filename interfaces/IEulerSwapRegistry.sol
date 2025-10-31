// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library IEulerSwap {
    struct StaticParams {
        address supplyVault0;
        address supplyVault1;
        address borrowVault0;
        address borrowVault1;
        address eulerAccount;
        address feeRecipient;
    }
}

interface IEulerSwapRegistry {
    error ChallengeBadAssets();
    error ChallengeLiquidityDeferred();
    error ChallengeMissingBond();
    error ChallengeNoBondAvailable();
    error ChallengeSwapNotLiquidityFailure();
    error ChallengeSwapSucceeded();
    error ChallengeUnauthorized();
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error E_AccountLiquidity();
    error InsufficientValidityBond();
    error InvalidVaultImplementation();
    error Locked();
    error NotAuthorized();
    error NotEulerSwapPool();
    error OldOperatorStillInstalled();
    error OperatorNotInstalled();
    error SafeERC20FailedOperation(address token);
    error SliceOutOfBounds();
    error Unauthorized();

    event CuratorTransferred(address indexed oldCurator, address indexed newCurator);
    event MinimumValidityBondUpdated(uint256 oldValue, uint256 newValue);
    event PoolChallenged(
        address indexed challenger,
        address indexed pool,
        address tokenIn,
        address tokenOut,
        uint256 amount,
        bool exactIn,
        uint256 bondAmount,
        address recipient
    );
    event PoolRegistered(
        address indexed asset0,
        address indexed asset1,
        address indexed eulerAccount,
        address pool,
        IEulerSwap.StaticParams sParams,
        uint256 validityBond
    );
    event PoolUnregistered(address indexed asset0, address indexed asset1, address indexed eulerAccount, address pool);
    event ValidVaultPerspectiveUpdated(address indexed oldPerspective, address indexed newPerspective);

    function EVC() external view returns (address);
    function challengePool(
        address poolAddr,
        address tokenIn,
        address tokenOut,
        uint256 amount,
        bool exactIn,
        address recipient
    ) external;
    function challengePoolAttempt(
        address challenger,
        address poolAddr,
        bool asset0IsInput,
        address tokenIn,
        uint256 amountIn,
        uint256 amountOut
    ) external;
    function curator() external view returns (address);
    function curatorUnregisterPool(address pool, address bondReceiver) external;
    function eulerSwapFactory() external view returns (address);
    function minimumValidityBond() external view returns (uint256);
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
    function registerPool(address poolAddr) external payable;
    function setMinimumValidityBond(uint256 newMinimum) external;
    function setValidVaultPerspective(address newPerspective) external;
    function transferCurator(address newCurator) external;
    function unregisterPool() external;
    function validVaultPerspective() external view returns (address);
    function validityBond(address pool) external view returns (uint256);
}
