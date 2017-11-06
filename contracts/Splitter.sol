pragma solidity ^0.4.4;

// @title: Splitter - This is just an exercise from the Ethereum Developer Course
// 			It allows splitting ether sent from the owner between other two contracts
// @author: Alberto Pulido

import "./Owned.sol";

contract Splitter is Owned {

	address public splitToAddressA;
	address public splitToAddressB;
	mapping (address => uint) public balances;
	

	event LogSplit(address indexed from, address indexed toA, address indexed toB, uint256 value, uint256 valueSplit);
	event LogWithdraw(address indexed from, uint256 valueWithdraw);

	function Splitter( address _splitToAddressA, address _splitToAddressB) public {
		splitToAddressA = _splitToAddressA;
		splitToAddressB = _splitToAddressB;
	}

	function split() payable public onlyOwner returns (bool splitIndeed) {
		require(msg.sender == owner);
        require(msg.value != 0);
		require(msg.value%2 == 0);
		uint amountToSplit = msg.value / 2;

		balances[splitToAddressA] += amountToSplit;
		balances[splitToAddressB] += amountToSplit;

		LogSplit(msg.sender, splitToAddressA, splitToAddressB, msg.value, amountToSplit);
		return true;
	}

	function withdrawFunds() public returns (bool success) {

		require(balances[msg.sender] > 0);
		uint balance = balances[msg.sender];
		balances[msg.sender] = 0;
		if (!msg.sender.send(balance)) throw;

		LogWithdraw(msg.sender, balance);

		return true;

	}

	function getBalanceOf(address account) public constant returns (uint balance) {
	
		return balances[account];

	}

}
