pragma solidity ^0.4.4;

contract Owned {
    
    address public owner;
    
    modifier onlyOwner { 
        if (msg.sender != owner) throw;
        _; 
    }
    
    function Owned() internal {
        owner = msg.sender;
    }

    
}