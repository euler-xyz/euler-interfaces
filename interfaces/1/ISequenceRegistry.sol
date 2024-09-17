// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISequenceRegistry {
    event SequenceIdReserved(string designator, uint256 indexed id, address indexed caller);

    function counters(string memory designator) external view returns (uint256 lastSeqId);
    function reserveSeqId(string memory designator) external returns (uint256);
}
