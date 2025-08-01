// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEscrowedCollateralPerspective {
    error PerspectiveError(address perspective, address vault, uint256 codes);
    error PerspectivePanic();

    event PerspectiveVerified(address indexed vault);

    function isVerified(address vault) external view returns (bool);
    function name() external pure returns (string memory);
    function perspectiveVerify(address vault, bool failEarly) external;
    function singletonLookup(address) external view returns (address);
    function vaultFactory() external view returns (address);
    function verifiedArray() external view returns (address[] memory);
    function verifiedLength() external view returns (uint256);
}
