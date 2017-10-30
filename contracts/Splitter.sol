pragma solidity ^0.4.4;

// @title: Splitter - This is just an exercise from the Ethereum Developer Course
// 			It allows splitting ether sent from the owner between other two contracts
// @author: Alberto Pulido

contract Splitter {
	address public owner;
	address public splitToAddressA;
	address public splitToAddressB;

	event Split(address indexed _from, address indexed _toA, address indexed _toB, uint256 _value, uint256 _valueSplit);

	function Splitter( address _splitToAddressA, address _splitToAddressB) {
		owner = msg.sender;
		splitToAddressA = _splitToAddressA;
		splitToAddressB = _splitToAddressB;
	}

	function split() payable returns (bool splitIndeed) {
		if( msg.sender != owner ) throw;
		uint amountSplit = msg.value / 2;
		splitToAddressA.transfer(amountSplit);
		splitToAddressB.transfer(amountSplit);
		Split(msg.sender, splitToAddressA, splitToAddressB, msg.value, amountSplit);
		return true;
	}

}
