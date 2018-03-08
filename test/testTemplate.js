'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
// YOUR CODE HERE
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
const User = artifacts.require("./User.sol");


contract('testTemplate', function(accounts) {
  /* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {_value: 1000, _tokenInitialAmount: 999999, _tokensIncrement: 5, _rate = 10, _duration = 1000, _queueTimecap = 100};
	let crowdsale1, smallUser1, bigUser2, bigUser3;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		crowdsale1 = await Crowdsale.new(_tokenInitialAmount, _rate, _duration, _queueTimecap);
		user1 = await User.new({value: args._value});
		user2 = await User.new({value: args._value});
		user3 = await User.new({value: args._value});
		await user1.setTarget(crowdsale1.address);
		await user1.setRate(_rate);
		await user2.setTarget(crowdsale1.address);
		await user2.setRate(_rate);
		await user3.setTarget(crowdsale1.address);
		await user3.setRate(_rate);
	});

	describe('~Basic Crowdsale-User connection check~', function() {

		it("check if all users are locked with the crowsale.",
			async function() {
				let cleanBalance = await user1.getBalance.call();
				assert.equal(cleanBalance.valueOf(), args._value,
					"balance for user set correctly");

				let targetAddress = await user1.getTargetCrowdSale()
				assert.equal(targetAddress, crowdsale1.address,
					"target address for user locked correctly");
		});	
	});	

	describe('~Basic Crowdsale check~', function() {
		it("check if have correct initialTokens amount in the contract.",
			async function() {
				let initialTokens = await crowdsale1.initialToken.call();
				assert.equal(initialTokens.valueOf(), args._bigInitialTokens,
					"initialTokens set correctly");
		});	
		
    });

	describe('~Token check in owner side (1/2)~', function() {
		beforeEach(async function() {
			//let queue1 = crowdsale1.queue.call();
			let queue1 = crowdsale1.queue;
		});

		it("check if mintTokens works.",
			async function() {		
				await crowdsale1.mintTokens(args._smallAmount);
				assert.equal(queue1.balanceOf(crowdsale1.address), args._bigInitialTokens + args._smallAmount,
					"mintTokens set correctly");
		});

		it("check if burnTokens works.",
			async function() {
				await crowdsale1.burnTokens(args._smallAmount);
				assert.equal(queue1.balanceOf(crowdsale1.address), args._bigInitialTokens - args._smallAmount,
					"burnTokens set correctly");
		});
    });

	describe('~Token check in user side~', function() {
		beforeEach(async function() {
			let queue1 = crowdsale1.queue;
			await user1.enterQueue();
			await user2.enterQueue();
		});

		it("check if buyToken works.",
			async function() {		

				await user1.buyToken(args._tokensIncrement);
				let balanceOfUser1FromCrowSale = crowdsale1.token.balanceOf(user1.address).call();
				let balanceOfUser1FromUser = user1.getMyTokenBalance.call();
				assert.equal(balanceOfUser1FromCrowSale, balanceOfUser1FromUser, 
					"buyToken set correctly");
		});

		it("check if refundTokens works.",
			async function() {
				await user1.buyToken(args._tokensIncrement);
				await user2.buyToken(args._tokensIncrement);
				await user1.refundToken(args._tokensIncrement);				
				let balanceOfUser1FromCrowSale = crowdsale1.token.balanceOf(user1.address).call();
				assert.isBelow(balanceOfUser1FromCrowSale, args._tokensIncrement, 
					"refundToken set correctly");
		});
    });

});
