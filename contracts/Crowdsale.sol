pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {

  address public owner;
  uint public initialTokens;
  uint public tokensToWei;
  uint private totalFunds;

  modifier ownerOnly() {
    require(msg.sender == owner);
    _;
  }

  function Crowdsale(uint initialTokens, uint tokensToWei) {
    owner = msg.sender;
  }

  function mintTokens(uint amount) ownerOnly {

  }

  function burnTokens(uint amount) ownerOnly {

  }


}
