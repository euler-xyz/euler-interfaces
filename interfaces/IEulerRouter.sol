// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerRouter {
    error ControllerDisabled();
    error EVC_InvalidAddress();
    error Governance_CallerNotGovernor();
    error NotAuthorized();
    error PriceOracle_InvalidConfiguration();
    error PriceOracle_NotSupported(address base, address quote);

    event ConfigSet(address indexed asset0, address indexed asset1, address indexed oracle);
    event FallbackOracleSet(address indexed fallbackOracle);
    event GovernorSet(address indexed oldGovernor, address indexed newGovernor);
    event ResolvedVaultSet(address indexed vault, address indexed asset);

    function EVC() external view returns (address);
    function fallbackOracle() external view returns (address);
    function getConfiguredOracle(address base, address quote) external view returns (address);
    function getQuote(uint256 inAmount, address base, address quote) external view returns (uint256);
    function getQuotes(uint256 inAmount, address base, address quote) external view returns (uint256, uint256);
    function govSetConfig(address base, address quote, address oracle) external;
    function govSetFallbackOracle(address _fallbackOracle) external;
    function govSetResolvedVault(address vault, bool set) external;
    function governor() external view returns (address);
    function name() external view returns (string memory);
    function resolveOracle(uint256 inAmount, address base, address quote)
        external
        view
        returns (uint256, address, address, address);
    function resolvedVaults(address vault) external view returns (address asset);
    function transferGovernance(address newGovernor) external;
}
