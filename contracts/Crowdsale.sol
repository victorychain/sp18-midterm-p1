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
    Token public token;
    Queue public queue;
    uint public initialTokens;
    uint public rate;
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

    function Crowdsale(uint _initialTokens, uint _rate, uint _duration, uint _queueTimecap) {
      owner = msg.sender;
      startTime = now;
      endTime = startTime + _duration;
      rate = _rate;
      initialTokens = _initialTokens;
      token = new Token(initialTokens);
      queue = new Queue(_queueTimecap);

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
        require(queue.qsize() < 5);
        queue.enqueue(msg.sender);
    }

    function checkTime() timeConstraint {
        queue.checkTime;
    }

    function checkPlace() timeConstraint {
        queue.checkPlace(msg.sender);
    }

    function buyTokens(uint amount) public payable timeConstraint {
      //increment token balance for msg.sender in Token.sol
      require(queue.getFirst() == msg.sender && queue.qsize() > 1);

      uint paidWei = msg.value;
      if (amount <= paidWei * rate) {
          tokensSold += amount;
          token.addToBalance(msg.sender, amount);
          totalFunds += paidWei;

          Queue(queue).dequeue();

          TokenPurchased(msg.sender);
      }

    }

    function refundTokens(uint amount) public timeConstraint {
      //decrement token balance for msg.sender in Token.sol
      tokensSold -= amount;
      token.removeFromBalance(msg.sender, amount);
      uint returnWei = amount / rate;
      msg.sender.transfer(returnWei);
      totalFunds -= returnWei;
      TokenSold(msg.sender);
    }

    function timeRemaining() view returns (uint) {
      return endTime - now;
    }

    function sendOwnerFunds() ownerOnly {
      require(now > endTime);
      owner.transfer(totalFunds);
    }

  }
