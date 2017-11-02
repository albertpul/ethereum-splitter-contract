pragma solidity ^0.4.4;

// @title: Splitter - This is just an exercise from the Ethereum Developer Course
// 			It allows splitting ether sent from the owner between other two contracts
// @author: Alberto Pulido

contract Splitter {
	address public owner;
	address public splitToAddressA;
	address public splitToAddressB;
	mapping (address => uint) amountPendingToWithdraw;

	event Split(address indexed _from, address indexed _toA, address indexed _toB, uint256 _value, uint256 _valueSplit);
	event Withdraw(address indexed _from, uint256 _valueWithdraw);

	function Splitter( address _splitToAddressA, address _splitToAddressB) {
		owner = msg.sender;
		splitToAddressA = _splitToAddressA;
		splitToAddressB = _splitToAddressB;
		amountPendingToWithdraw[splitToAddressA] = 0;
		amountPendingToWithdraw[splitToAddressB] = 0;
	}

	function split() payable returns (bool splitIndeed) {
		require(msg.sender == owner);
        require(msg.value != 0);
		uint amountToSplit = (msg.value - msg.value%2) / 2;

		amountPendingToWithdraw[splitToAddressA]+=amountToSplit;
		amountPendingToWithdraw[splitToAddressB]+=amountToSplit;

		Split(msg.sender, splitToAddressA, splitToAddressB, msg.value, amountToSplit);
		return true;
	}

	function withdrawFunds() returns (bool success){

		require( msg.sender == splitToAddressA || msg.sender == splitToAddressB );
		require( amountPendingToWithdraw[msg.sender] > 0 );
		uint availableFunds = amountPendingToWithdraw[msg.sender];
		amountPendingToWithdraw[msg.sender] = 0;
		msg.sender.transfer(availableFunds);

		Withdraw(msg.sender, availableFunds);

		return true;

	}

	function getAvailableFunds(address account) returns (uint availableFunds){

		require((msg.sender == splitToAddressA && account == splitToAddressA) ||
				 (msg.sender == splitToAddressB  && account == splitToAddressB) || 
				 msg.sender == owner);
		
		return amountPendingToWithdraw[msg.sender];

	}

}
