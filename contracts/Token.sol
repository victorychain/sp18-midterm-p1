pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	uint public totalSupply;
	mapping (address => uint) public balance;

  function Token(uint initialSupply) {
      totalSupply = initialSupply;
  }

  function addTokens(uint amount) {
    totalSupply += amount;
  }

  function removeTokens(uint amount) {
    totalSupply -= amount;
  }

  function addToBalance(address buyer, uint amount) {
    balance[buyer] += amount;
  }

  function removeFromBalance(address seller, uint amount) {
    balance[buyer] -= amount;
  }
}
