// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Functions {
    string public name;
    uint256 public startTime;

    constructor() {
        name = "Functions";
        startTime = block.timestamp;
    }
}

contract Functionss{
    uint256 public myNumber = 1000000;

    function readOnly() public view returns(uint256) {
        return myNumber;
    }

    function writeOnly() public {
        myNumber = addOne(myNumber);
    }

    function addOne(uint256 _input) internal pure returns(uint256) {
        return _input + 1;
    }
}

contract EventErrors {
    address public owner;

    event Hello(address user, string message);
    error Unauthorized();

    function sayHello() public {
        emit Hello(msg.sender, "Hello World!");
    }

    function sayHi() public {
        // if (msg.sender != owner) revert Unauthorized();
        require(msg.sender == owner, "Unauthorized");
        emit Hello(msg.sender, "Hi World!");
    }
}