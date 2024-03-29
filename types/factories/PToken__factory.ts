/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type { PToken, PTokenInterface } from "../PToken";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        type: "address",
        name: "euler_",
      },
      {
        name: "underlying_",
        type: "address",
        internalType: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        indexed: true,
        name: "owner",
        internalType: "address",
        type: "address",
      },
      {
        type: "address",
        internalType: "address",
        name: "spender",
        indexed: true,
      },
      {
        name: "value",
        indexed: false,
        internalType: "uint256",
        type: "uint256",
      },
    ],
    name: "Approval",
    anonymous: false,
    type: "event",
  },
  {
    type: "event",
    anonymous: false,
    name: "Transfer",
    inputs: [
      {
        indexed: true,
        name: "from",
        internalType: "address",
        type: "address",
      },
      {
        name: "to",
        indexed: true,
        type: "address",
        internalType: "address",
      },
      {
        indexed: false,
        name: "value",
        type: "uint256",
        internalType: "uint256",
      },
    ],
  },
  {
    type: "function",
    stateMutability: "view",
    name: "allowance",
    inputs: [
      {
        name: "holder",
        internalType: "address",
        type: "address",
      },
      {
        internalType: "address",
        type: "address",
        name: "spender",
      },
    ],
    outputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
  },
  {
    outputs: [
      {
        name: "",
        internalType: "bool",
        type: "bool",
      },
    ],
    inputs: [
      {
        name: "spender",
        type: "address",
        internalType: "address",
      },
      {
        name: "amount",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    name: "approve",
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    name: "balanceOf",
    outputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    inputs: [
      {
        type: "address",
        internalType: "address",
        name: "who",
      },
    ],
    type: "function",
    stateMutability: "view",
  },
  {
    name: "claimSurplus",
    outputs: [],
    inputs: [
      {
        name: "who",
        type: "address",
        internalType: "address",
      },
    ],
    type: "function",
    stateMutability: "nonpayable",
  },
  {
    outputs: [
      {
        name: "",
        internalType: "uint8",
        type: "uint8",
      },
    ],
    inputs: [],
    name: "decimals",
    stateMutability: "view",
    type: "function",
  },
  {
    type: "function",
    stateMutability: "nonpayable",
    name: "forceUnwrap",
    inputs: [
      {
        name: "who",
        type: "address",
        internalType: "address",
      },
      {
        name: "amount",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    outputs: [],
  },
  {
    type: "function",
    stateMutability: "view",
    name: "name",
    outputs: [
      {
        internalType: "string",
        type: "string",
        name: "",
      },
    ],
    inputs: [],
  },
  {
    name: "symbol",
    outputs: [
      {
        name: "",
        internalType: "string",
        type: "string",
      },
    ],
    inputs: [],
    type: "function",
    stateMutability: "view",
  },
  {
    outputs: [
      {
        internalType: "uint256",
        type: "uint256",
        name: "",
      },
    ],
    inputs: [],
    name: "totalSupply",
    stateMutability: "view",
    type: "function",
  },
  {
    stateMutability: "nonpayable",
    type: "function",
    inputs: [
      {
        name: "recipient",
        type: "address",
        internalType: "address",
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
      },
    ],
    outputs: [
      {
        type: "bool",
        internalType: "bool",
        name: "",
      },
    ],
    name: "transfer",
  },
  {
    outputs: [
      {
        name: "",
        type: "bool",
        internalType: "bool",
      },
    ],
    inputs: [
      {
        name: "from",
        type: "address",
        internalType: "address",
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    stateMutability: "view",
    type: "function",
    inputs: [],
    outputs: [
      {
        internalType: "address",
        type: "address",
        name: "",
      },
    ],
    name: "underlying",
  },
  {
    type: "function",
    stateMutability: "nonpayable",
    name: "unwrap",
    outputs: [],
    inputs: [
      {
        name: "amount",
        type: "uint256",
        internalType: "uint256",
      },
    ],
  },
  {
    stateMutability: "nonpayable",
    type: "function",
    inputs: [
      {
        internalType: "uint256",
        type: "uint256",
        name: "amount",
      },
    ],
    outputs: [],
    name: "wrap",
  },
];

export class PToken__factory {
  static readonly abi = _abi;
  static createInterface(): PTokenInterface {
    return new utils.Interface(_abi) as PTokenInterface;
  }
  static connect(address: string, signerOrProvider: Signer | Provider): PToken {
    return new Contract(address, _abi, signerOrProvider) as PToken;
  }
}
