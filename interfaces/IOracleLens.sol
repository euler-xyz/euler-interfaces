// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracleLens {
    struct OracleDetailedInfo {
        address oracle;
        string name;
        bytes oracleInfo;
    }

    function TTL_ERROR() external view returns (int256);
    function TTL_INFINITY() external view returns (int256);
    function TTL_LIQUIDATION() external view returns (int256);
    function TTL_MORE_THAN_ONE_YEAR() external view returns (int256);
    function adapterRegistry() external view returns (address);
    function getOracleInfo(address oracleAddress, address[] memory bases, address[] memory quotes)
        external
        view
        returns (OracleDetailedInfo memory);
    function getValidAdapters(address base, address quote) external view returns (address[] memory);
    function isStalePullOracle(address oracleAddress, bytes memory failureReason) external view returns (bool);
}
