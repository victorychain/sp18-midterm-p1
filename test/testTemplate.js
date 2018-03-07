'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require('./Crowdsale.sol');
const Queue = artifacts.require('./Queue.sol');
const Token = artifacts.require('./Token.sol');

contract('testTemplate', accounts => {
  /* Define your constant variables and instantiate constantly changing
	 * ones
	 */
  const args = {
    _initialTokens: 1000,
    _rate: 10,
    _duration: 600,
    _queueTimecap: 60
  };
  let crowdsale, queue, token;

  /* Do something before every `describe` method */
  beforeEach(async () => {
    /* Deploy a new Crowdsale Contract */

    crowdsale = await Crowdsale.new({
      _initialTokens: args._initialTokens,
      _rate: args._rate,
      _duration: args._duration,
      _queueTimecap: args._queueTimecap
    });
  });

  /* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
  describe('Crowdsale Works', () => {
    it('has ', async () => {
      let initialTokens = await crowdsale.initialTokens.call();
      assert.equal(initialTokens.valueOf(), args._initialTokens);
    });
  });

  describe('Your string here', () => {
    // YOUR CODE HERE
  });
});
