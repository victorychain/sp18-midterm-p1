pragma solidity 0.4.19;

import "./Crowdsale.sol";

/** @title NotPoisoned */
contract User {

	address targetCrowdSale;
	uint targetRate;
	uint totalToken;


	/* Constructor */
	function User() payable {}

	function enterQueue() external {
		if (targetCrowdSale != address(0)){
			Crowdsale _targetCrowdSale = Crowdsale(targetCrowdSale);
			_targetCrowdSale.enterQueue();
		}
	}

	function checkTime() external {
		if (targetCrowdSale != address(0)){
			Crowdsale _targetCrowdSale = Crowdsale(targetCrowdSale);
			_targetCrowdSale.checkTime();
		}
	}

	function checkPlace() external {
		if (targetCrowdSale != address(0)){
			Crowdsale _targetCrowdSale = Crowdsale(targetCrowdSale);
			_targetCrowdSale.checkPlace();
		}
	}

	function buyTokens(uint amount) external {
		if ((amount <= this.balance * targetRate) && (targetCrowdSale != address(0))) {
			Crowdsale _targetCrowdSale = Crowdsale(targetCrowdSale);
			_targetCrowdSale.buyTokens.value(amount);
			totalToken = totalToken + amount;
		}
	}

	function refundTokens(uint amount) external {
		if ((amount <= totalToken) && (targetCrowdSale != address(0))) {
			Crowdsale _targetCrowdSale = Crowdsale(targetCrowdSale);
			_targetCrowdSale.refundTokens.value(amount);
			totalToken = totalToken - amount;
		}
	}

//_target.bid.value(amount)();

	function setRate(uint rate) external {
		if (targetCrowdSale != address(this)) {
			targetRate = rate;
		}
	}

	function setTarget(address crowdSale) external {
		if (crowdSale != address(this)) {
			targetCrowdSale = crowdSale;
		}
	}

	function getTargetRate() constant returns (uint) {
		return targetRate;
	}

	function getTargetCrowdSale() constant returns (address) {
		return targetCrowdSale;
	}

	function getMyTokenBalance() constant returns (uint) {
		return totalToken;
	}

	function getBalance() constant returns (uint) {
		return this.balance;
	}

	function() payable {}
}
