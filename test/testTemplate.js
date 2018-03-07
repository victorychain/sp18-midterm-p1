'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
// YOUR CODE HERE
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");



contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_bigInitialTokens: 99999999999999, _smallInitialTokens: 999, _highRate = 100, _lowRate = 10, _duration = 1000, _queueTimecap = 100};
	let x, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		x = await Crowdsale.new(_bigInitialTokens, _highRate, _duration, _queueTimecap);
		//y = await Queue.new();
		//z = await Token.new();
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Your string here', function() {

		it("your string here", async function() {
			// YOUR CODE HERE
		});
		// YOUR CODE HERE
	});
	describe('Your string here', function() {

		beforeEach(async function() {
			/* Deploy Poisoned to carry out attack */
			await poisoned.setTarget(good.address);
		});

		it("your string here", async function() {
			// YOUR CODE HERE
		});
		// YOUR CODE HERE
	});






/*
	describe('Your string here', function() {
		// YOUR CODE HERE
	});
*/
});
