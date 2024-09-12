// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEulerKinkIRMFactory {
    error Factory_BadQuery();
    error IRMFactory_ExcessiveInterestRate();

    event ContractDeployed(address indexed deployedContract, address indexed deployer, uint256 deployedAt);

    function deploy(uint256 baseRate, uint256 slope1, uint256 slope2, uint32 kink) external returns (address);
    function deployments(uint256) external view returns (address);
    function getDeploymentInfo(address contractAddress) external view returns (address deployer, uint96 deployedAt);
    function getDeploymentsListLength() external view returns (uint256);
    function getDeploymentsListSlice(uint256 start, uint256 end) external view returns (address[] memory list);
    function isValidDeployment(address contractAddress) external view returns (bool);
}