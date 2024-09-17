// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerRouterFactory {
    error Factory_BadQuery();

    event ContractDeployed(address indexed deployedContract, address indexed deployer, uint256 deployedAt);

    function EVC() external view returns (address);
    function deploy(address governor) external returns (address);
    function deployments(uint256) external view returns (address);
    function getDeploymentInfo(address contractAddress) external view returns (address deployer, uint96 deployedAt);
    function getDeploymentsListLength() external view returns (uint256);
    function getDeploymentsListSlice(uint256 start, uint256 end) external view returns (address[] memory list);
    function isValidDeployment(address contractAddress) external view returns (bool);
}
