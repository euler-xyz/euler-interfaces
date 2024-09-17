// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProtocolConfig {
    error E_InvalidAdmin();
    error E_InvalidConfigValue();
    error E_InvalidReceiver();
    error E_InvalidVault();
    error E_OnlyAdmin();

    event SetAdmin(address indexed newAdmin);
    event SetFeeConfigSetting(address indexed vault, bool exists, address indexed feeReceiver, uint16 protocolFeeShare);
    event SetFeeReceiver(address indexed newFeeReceiver);
    event SetInterestFeeRange(uint16 newMinInterestFee, uint16 newMaxInterestFee);
    event SetProtocolFeeShare(uint16 protocolFeeShare, uint16 newProtocolFeeShare);
    event SetVaultInterestFeeRange(address indexed vault, bool exists, uint16 minInterestFee, uint16 maxInterestFee);

    function admin() external view returns (address);
    function feeReceiver() external view returns (address);
    function interestFeeRange(address vault) external view returns (uint16, uint16);
    function isValidInterestFee(address vault, uint16 interestFee) external view returns (bool);
    function protocolFeeConfig(address vault) external view returns (address, uint16);
    function setAdmin(address newAdmin) external;
    function setFeeReceiver(address newReceiver) external;
    function setInterestFeeRange(uint16 minInterestFee_, uint16 maxInterestFee_) external;
    function setProtocolFeeShare(uint16 newProtocolFeeShare) external;
    function setVaultFeeConfig(address vault, bool exists_, address feeReceiver_, uint16 protocolFeeShare_) external;
    function setVaultInterestFeeRange(address vault, bool exists_, uint16 minInterestFee_, uint16 maxInterestFee_)
        external;
}
