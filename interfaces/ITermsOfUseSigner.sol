// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITermsOfUseSigner {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error InvalidTermsOfUseHash(bytes32 actualTermsOfUseHash, bytes32 expectedTermsOfUseHash);
    error NotAuthorized();

    event TermsOfUseSigned(address indexed account, bytes32 indexed termsOfUseHash, uint256 timestamp, string message);

    function EVC() external view returns (address);
    function lastTermsOfUseSignatureTimestamp(address account, bytes32 termsOfUseHash)
        external
        view
        returns (uint256);
    function signTermsOfUse(string memory termsOfUseMessage, bytes32 termsOfUseHash) external;
}
