// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library IMorpho {
    struct MarketParams {
        address loanToken;
        address collateralToken;
        address oracle;
        address irm;
        uint256 lltv;
    }
}

interface ISwapVerifier {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error NotAuthorized();
    error SafeERC20FailedOperation(address token);
    error SwapVerifier_debtMax();
    error SwapVerifier_depositMin();
    error SwapVerifier_pastDeadline();
    error SwapVerifier_skimMin();
    error SwapVerifier_transferMin();

    function EVC() external view returns (address);
    function aaveBorrowForSender(address pool, address asset, uint256 amount, address to) external;
    function morphoBorrowForSender(address morpho, IMorpho.MarketParams memory marketParams, uint256 amount, address to)
        external;
    function morphoWithdrawCollateralForSender(
        address morpho,
        IMorpho.MarketParams memory marketParams,
        uint256 amount,
        address to
    ) external;
    function permit2() external view returns (address);
    function transferBalanceFromSender(address token, uint256 maxAmount, address to) external returns (uint256 amount);
    function transferFromSender(address token, uint256 amount, address to) external;
    function verifyAmountMinAndDeposit(address vault, address receiver, uint256 amountMin, uint256 deadline) external;
    function verifyAmountMinAndSkim(address vault, address receiver, uint256 amountMin, uint256 deadline) external;
    function verifyAmountMinAndTransfer(address asset, address receiver, uint256 amountMin, uint256 deadline) external;
    function verifyDebtMax(address vault, address account, uint256 amountMax, uint256 deadline) external view;
}
