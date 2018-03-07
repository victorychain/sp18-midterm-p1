pragma solidity ^0.4.15;

import 'interfaces/ERC20Interface.sol';
import 'utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token {

	// Balances for each account
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint)) allowed;
	uint totalSupply;


	function Token(uint256 _totalSupply) {
		totalSupply = _totalSupply;
	}

	/// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] < _value) {
            return false;
        }
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[_to] -= SafeMath.add(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
            return false;
        }
        balances[_from] = SafeMath.sub(balances[_from], _value);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
        balances[_to] -= SafeMath.add(balances[_to], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function burn(address _from, uint256 _value) returns (bool success) {
        if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
            return false;
        }
        balances[_from] = SafeMath.sub(balances[_from], _value);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
        totalSupply = SafeMath.sub(totalSupply, _value);
        Burn(_from, _value);
        return true;
    }

    function addTokens(uint amount) {
    	totalSupply = SafeMath.add(totalSupply, amount);
    }

    function removeTokens(uint amount) {
    	totalSupply = SafeMath.sub(totalSupply, amount);
    }

    function addToBalance(address buyer, uint amount) {
    	balances[buyer] = SafeMath.add(balances[buyer], amount);
    }

    function removeFromBalance(address seller, uint amount) {
      	balances[seller] = SafeMath.sub(balances[seller], amount);
    }

    function () public payable {
        revert();
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, uint256 _value);
}
