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

  function mintTokens(uint amount) ownerOnly {
    //add to totalSupply in Token.sol
    token.addTokens(amount);
  }

  function burnTokens(uint amount) ownerOnly {
    //subtract from totalSupply in Token.sol
    token.removeTokens(amount);
  }

  function enterQueue() timeConstraint {
      address line = Queue.at(queue);

      require(line.qsize() < 5);
      line.enqueue(msg.sender);
  }

  function checkTime() timeConstraint {
      address line = Queue.at(queue);
      if (line.checkTime) {
          line.dequeue;
      }
  }

  function checkPlace() timeConstraint {
      return Queue.at(queue).checkPlace(msg.sender);
  }

  function buyTokens(uint amount) public timeConstraint {
    //increment token balance for msg.sender in Token.sol
    address line = Queue.at(queue);
    require(line.getFirst() == msg.sender && line.qsize() > 1);

    uint paidWei = msg.value;
    if (amount <= paidWei * rate) {
        tokensSold += amount;
        token.addToBalance(msg.sender, amount);
        totalFunds += paidWei;

        line.dequeue();

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
    return endTime - startTime;
  }

  function sendOwnerFunds() ownerOnly {
    require(now > endTime);
    owner.transfer(totalFunds);
  }

}
