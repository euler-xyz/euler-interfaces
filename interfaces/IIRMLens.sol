// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IIRMLens {
    type InterestRateModelType is uint8;

    struct InterestRateModelDetailedInfo {
        address interestRateModel;
        InterestRateModelType interestRateModelType;
        bytes interestRateModelParams;
    }

    function TTL_ERROR() external view returns (int256);
    function TTL_INFINITY() external view returns (int256);
    function TTL_LIQUIDATION() external view returns (int256);
    function TTL_MORE_THAN_ONE_YEAR() external view returns (int256);
    function adaptiveCurveIRMFactory() external view returns (address);
    function fixedCyclicalBinaryIRMFactory() external view returns (address);
    function getInterestRateModelInfo(address irm) external view returns (InterestRateModelDetailedInfo memory);
    function kinkIRMFactory() external view returns (address);
    function kinkyIRMFactory() external view returns (address);
}
