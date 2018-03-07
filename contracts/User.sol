
pragma solidity 0.4.19;

import "./Crowsale.sol";

/** @title NotPoisoned */
contract User {

	address targetCrowdSale;
	uint targetRate;
	uint totalToken;


	/* Constructor */
	function User() payable {}

	function enterQueue() external {
		if (target != address(0)){
			Crowsale _targetCrowSale = Crowsale(targetCrowdSale);
			_targetCrowSale.enterQueue();
		}
	}

	function checkTime() external {
		if (target != address(0)){
			Crowsale _targetCrowSale = Crowsale(targetCrowdSale);
			_targetCrowSale.checkTime();
		}
	}

	function checkPlace() external {
		if (target != address(0)){
			Crowsale _targetCrowSale = Crowsale(targetCrowdSale);
			_targetCrowSale.checkPlace();
		}
	}

	function buyTokens(uint amount) external {
		if ((amount <= this.balance * this.targetRate) && (target != address(0))) {
			Crowsale _targetCrowSale = Crowsale(targetCrowdSale);
			_targetCrowSale.buyTokens.value(amount)();
			totalToken = totalToken + amount;
		}
	}

	function refundTokens(uint amount) external {
		if ((amount <= this.totalToken) && (target != address(0))) {
			Crowsale _targetCrowSale = Crowsale(targetCrowdSale);
			_targetCrowSale.refundTokens.value(amount)();
			totalToken = totalToken - amount;
		}
	}

//_target.bid.value(amount)();

	function setRate(uint rate) external {
		if (crowSale != address(this)) {
			targetRate = rate;
		}
	}

	function setTarget(address crowSale) external {
		if (crowSale != address(this)) {
			targetCrowdSale = crowSale;
		}
	}

	function getTargetRate() constant returns (uint) {
		return targetRate;
	}

	function getTargetCrowdSale() constant returns (address) {
		return targetCrowdSale;
	}

	function getMyTokenBalance() constant returns (address) {
		return totalToken;
	}

	function getBalance() constant returns (uint) {
		return this.balance;
	}

	function() payable {}
}
