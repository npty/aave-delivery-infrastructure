// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IOwnable} from "solidity-utils/contracts/transparent-proxy/interfaces/IOwnable.sol";

import "../BaseScript.sol";

abstract contract Finalize is BaseScript {

  function DAO_AGENT() public view virtual returns (address) {
    return address(0);
  }

  function _execute(DeployerHelpers.Addresses memory addresses) internal override {

    // If no DAO_AGENT is set, use the executor as the DAO_AGENT for the network
    address daoAgentAddress = DAO_AGENT() == address(0)
      ? addresses.executor
      : DAO_AGENT();

    // Transfer CrossChainController ownership to the DAO
    IOwnable(addresses.crossChainController).transferOwnership(daoAgentAddress);

    // Transfer proxy admin ownership to the DAO
    IOwnable(addresses.proxyAdmin).transferOwnership(daoAgentAddress);
  }
}

contract Ethereum is Finalize {
  // https://docs.lido.fi/deployed-contracts/#dao-contracts Aragon Agent
  function DAO_AGENT() public view virtual override returns (address) {
    return 0x3e40D73EB977Dc6a537aF587D48316feE66E9C8c;
  }

  function TRANSACTION_NETWORK() public pure virtual override returns (uint256) {
    return ChainIds.ETHEREUM;
  }
}

contract Ethereum_testnet is Finalize {
  // https://docs.lido.fi/deployed-contracts/sepolia#dao-contracts Aragon Agent
  function DAO_AGENT() public view virtual override returns (address) {
    return 0x32A0E5828B62AAb932362a4816ae03b860b65e83;
  }

  function TRANSACTION_NETWORK() public pure virtual override returns (uint256) {
    return TestNetChainIds.ETHEREUM_SEPOLIA;
  }
}

contract Binance is Finalize {
  function TRANSACTION_NETWORK() public pure virtual override returns (uint256) {
    return ChainIds.BNB;
  }
}

contract Binance_testnet is Finalize {
  function TRANSACTION_NETWORK() public pure virtual override returns (uint256) {
    return TestNetChainIds.BNB_TESTNET;
  }
}
