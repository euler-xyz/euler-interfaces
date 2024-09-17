// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwapVerifier {
    error SwapVerifier_debtMax();
    error SwapVerifier_pastDeadline();
    error SwapVerifier_skimMin();

    function verifyAmountMinAndSkim(address vault, address receiver, uint256 amountMin, uint256 deadline) external;
    function verifyDebtMax(address vault, address account, uint256 amountMax, uint256 deadline) external view;
}
