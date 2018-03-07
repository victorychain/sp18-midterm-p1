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

  function Crowdsale(uint _initialTokens, uint _rate, uint duration, uint queueTimecap) {
    owner = msg.sender;
    startTime = now;
    endTime = startTime + duration;
    rate = _rate;
    initialTokens = _initialTokens;

    token = new Token(initialTokens);
    queue = new Queue(queueTimecap);

  }

  function createToken(uint initialTokens) ownerOnly {
      token = new Token(initialTokens);
  }

  function mintTokens(uint amount) ownerOnly {
    //add to totalSupply in Token.sol
    Token(token).addTokens(amount);
  }

  function burnTokens(uint amount) ownerOnly {
    //subtract from totalSupply in Token.sol
    Token(token).removeTokens(amount);
  }

  function enterQueue() timeConstraint {
      require(Queue(queue).qsize() < 5);
      Queue(queue).enqueue(msg.sender);
  }

  function checkTime() timeConstraint {
      Queue(queue).checkTime;
  }

  function checkPlace() timeConstraint {
      Queue(queue).checkPlace(msg.sender);
  }

  function buyTokens(uint amount) public timeConstraint {
    //increment token balance for msg.sender in Token.sol
    require(Queue(queue).getFirst() == msg.sender && Queue(queue).qsize() > 1);

    uint paidWei = msg.value;
    if (amount <= paidWei * rate) {
        tokensSold += amount;
        Token(token).addToBalance(msg.sender, amount);
        totalFunds += paidWei;

        Queue(queue).dequeue();

        TokenPurchased(msg.sender);
    }

  }

  function refundTokens(uint amount) public timeConstraint {
    //decrement token balance for msg.sender in Token.sol
    tokensSold -= amount;
    Token(token).removeFromBalance(msg.sender, amount);
    uint returnWei = amount / rate;
    msg.sender.transfer(returnWei);
    totalFunds -= returnWei;
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
