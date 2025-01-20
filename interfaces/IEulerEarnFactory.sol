// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerEarnFactory {
    error FailedDeployment();
    error InsufficientBalance(uint256 balance, uint256 needed);
    error InvalidQuery();

    event DeployEulerEarn(address indexed _owner, address _eulerEarnVault, address indexed _asset);

    function deployEulerEarn(
        address _asset,
        string memory _name,
        string memory _symbol,
        uint256 _initialCashAllocationPoints,
        uint24 _smearingPeriod
    ) external returns (address);
    function eulerEarnImpl() external view returns (address);
    function eulerEarnVaults(uint256) external view returns (address);
    function getEulerEarnVaultsListLength() external view returns (uint256);
    function getEulerEarnVaultsListSlice(uint256 _start, uint256 _end) external view returns (address[] memory);
    function isValidDeployment(address _earnVaultAddress) external view returns (bool);
}
