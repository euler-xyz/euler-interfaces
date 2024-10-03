// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IIRMLinearKink {
    error E_IRMUpdateUnauthorized();

    function baseRate() external view returns (uint256);
    function computeInterestRate(address vault, uint256 cash, uint256 borrows) external view returns (uint256);
    function computeInterestRateView(address vault, uint256 cash, uint256 borrows) external view returns (uint256);
    function kink() external view returns (uint256);
    function slope1() external view returns (uint256);
    function slope2() external view returns (uint256);
}
