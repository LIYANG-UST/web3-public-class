// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Saving {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastInterestTimes;
    mapping(address => uint256) public pendingInterests;

    uint256 public interestRate = 10; // 10% interest;

    event Deposit(address user, uint256 amount);
    event Compound(address user);
    event Withdraw(address user, uint256 amount);


    function deposit() public payable {
        require(msg.value > 0 , "Can not deposit 0");

        _updateInterest(msg.sender);
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function compound() public {
        _updateInterest(msg.sender);

        balances[msg.sender] += pendingInterests[msg.sender];
        pendingInterests[msg.sender] = 0;

        emit Compound(msg.sender);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Can not withdraw 0");

        _updateInterest(msg.sender);

        uint256 amount = balances[msg.sender] + pendingInterests[msg.sender];

        pendingInterests[msg.sender] = 0;
        balances[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }

    function _updateInterest(address _user) internal {
        uint256 lastInterestTime = lastInterestTimes[_user];

        if (lastInterestTime > 0) {
            uint256 timeDiff = block.timestamp - lastInterestTime;
            uint256 interestAmount = balances[_user] * interestRate * timeDiff / 365 days / 100;

            pendingInterests[_user] += interestAmount;
        }

        lastInterestTimes[_user] = block.timestamp;
    }
}