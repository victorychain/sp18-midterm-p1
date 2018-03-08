var Crowdsale = artifacts.require('./Crowdsale.sol');
var Queue = artifacts.require('./Queue.sol');
var Token = artifacts.require('./Token.sol');
var User = artifacts.require('./User.sol');

const args = {
  _value: 1000,
  _tokenInitialAmount: 999999,
  _tokensIncrement: 5,
  _rate: 10,
  _duration: 1000,
  _queueTimecap: 100
};

module.exports = function(deployer) {
  deployer.deploy(
    Crowdsale,
    args._tokenInitialAmount,
    args._rate,
    args._duration,
    args._queueTimecap
  );
  deployer.deploy(Queue, args._queueTimecap);
  deployer.deploy(Token, args._tokenInitialAmount);
  deployer.deploy(User);
};
