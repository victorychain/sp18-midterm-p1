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
  address public queue;
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

  function Crowdsale(uint _initialTokens, uint _tokensPerWei, uint duration, uint queueTimecap) {
    owner = msg.sender;
    startTime = now;
    endTime = startTime + duration;
    tokensPerWei = _tokensPerWei;
    initialTokens = _initialTokens;

    token = new Token(initialTokens);
    queue = new Queue(queueTimecap);

  }

  function mintTokens(uint amount) ownerOnly {
    //add to totalSupply in Token.sol
    token.addTokens(amount);
  }

  function burnTokens(uint amount) ownerOnly {
    //subtract from totalSupply in Token.sol
    token.removeTokens(amount);
  }

  function enterQueue() timeConstraint {
      line = Queue.at(queue);

      require(line.qsize() < 5);
      line.enqueue(msg.sender);
  }

  function checkTime() timeConstraint {
      line = Queue.at(queue);
      if (line.checkTime) {
          line.dequeue;
      }
  }

  function checkPlace() timeConstraint {
      return Queue.at(queue).checkPlace(msg.sender);
  }

  function buyTokens(uint amount) public timeConstraint {
    //increment token balance for msg.sender in Token.sol
    line = Queue.at(queue);
    require(line.getFirst() == msg.sender && line.qsize() > 1);

    tokensSold += amount;
    token.addToBalance(msg.sender, amount);

    line.dequeue();

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
