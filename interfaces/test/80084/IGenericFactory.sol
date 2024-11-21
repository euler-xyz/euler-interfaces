// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library GenericFactory {
    struct ProxyConfig {
        bool upgradeable;
        address implementation;
        bytes trailingData;
    }
}

interface IGenericFactory {
    error E_BadAddress();
    error E_BadQuery();
    error E_DeploymentFailed();
    error E_Implementation();
    error E_Reentrancy();
    error E_Unauthorized();

    event Genesis();
    event ProxyCreated(address indexed proxy, bool upgradeable, address implementation, bytes trailingData);
    event SetImplementation(address indexed newImplementation);
    event SetUpgradeAdmin(address indexed newUpgradeAdmin);

    function createProxy(address desiredImplementation, bool upgradeable, bytes memory trailingData)
        external
        returns (address);
    function getProxyConfig(address proxy) external view returns (GenericFactory.ProxyConfig memory config);
    function getProxyListLength() external view returns (uint256);
    function getProxyListSlice(uint256 start, uint256 end) external view returns (address[] memory list);
    function implementation() external view returns (address);
    function isProxy(address proxy) external view returns (bool);
    function proxyList(uint256) external view returns (address);
    function setImplementation(address newImplementation) external;
    function setUpgradeAdmin(address newUpgradeAdmin) external;
    function upgradeAdmin() external view returns (address);
}
