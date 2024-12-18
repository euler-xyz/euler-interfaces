// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwapper {
    struct SwapParams {
        bytes32 handler;
        uint256 mode;
        address account;
        address tokenIn;
        address tokenOut;
        address vaultIn;
        address accountIn;
        address receiver;
        uint256 amountOut;
        bytes data;
    }

    error E_EmptyError();
    error Swapper_Reentrancy();
    error Swapper_SwapError(address swapProvider, bytes rawError);
    error Swapper_TargetDebt();
    error Swapper_UnknownHandler();
    error Swapper_UnknownMode();
    error Swapper_UnsupportedMode();
    error UniswapV2Handler_InvalidPath();
    error UniswapV3Handler_InvalidPath();

    function HANDLER_GENERIC() external view returns (bytes32);
    function HANDLER_UNISWAP_V2() external view returns (bytes32);
    function HANDLER_UNISWAP_V3() external view returns (bytes32);
    function deposit(address token, address vault, uint256 amountMin, address account) external;
    function multicall(bytes[] memory calls) external;
    function repay(address token, address vault, uint256 repayAmount, address account) external;
    function repayAndDeposit(address token, address vault, uint256 repayAmount, address account) external;
    function swap(SwapParams memory params) external;
    function sweep(address token, uint256 amountMin, address to) external;
    function uniswapRouterV2() external view returns (address);
    function uniswapRouterV3() external view returns (address);
}
