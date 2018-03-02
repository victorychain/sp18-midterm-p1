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
  address public token;
  uint public initialTokens;
  uint public tokensPerWei;
  uint private totalFunds;
  uint public startTime;
  uint public endTime;
  uint public tokensSold;

  modifier ownerOnly() {
    require(msg.sender == owner);
    _;
  }

  modifier timeConstraint() {
      require(now > startTime && now < endTime);
      _;
  }

   event TokenPurchased(address buyer);
   event TokenSold(address seller);

  function Crowdsale(uint _initialTokens, uint _tokensPerWei, uint duration) {
    owner = msg.sender;
    startTime = now;
    endTime = startTime + duration;
    tokensPerWei = _tokensPerWei;
    initialTokens = _initialTokens;

    token = new Token(initialTokens);

  }

  function mintTokens(uint amount) ownerOnly {
    //add to totalSupply in Token.sol
    token.addTokens(amount);
  }

  function burnTokens(uint amount) ownerOnly {
    //subtract from totalSupply in Token.sol
    token.removeTokens(amount);
  }

  function buyTokens(uint amount) public timeConstraint {
    //increment token balance for msg.sender in Token.sol
    tokensSold += amount;
    token.addToBalance(msg.sender, amount);
    TokenPurchased(msg.sender);
  }

  function refundTokens(uint amount) public timeConstraint {
    //decrement token balance for msg.sender in Token.sol
    tokensSold -= amount;
    token.removeFromBalance(msg.sender, amount);
    TokenSold(msg.sender);
  }

  function timeRemaining() view returns (uint) {
    return endTime - startTime;
  }

  function sendOwnerFunds() ownerOnly {
    require(now > endTime);
    owner.transfer(totalFunds);
  }

}
