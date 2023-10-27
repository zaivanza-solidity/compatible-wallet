//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0; 

contract Wallet {
    address owner;
    mapping (address => uint256) public users;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner");
        _;
    }

    function addUser(address _user, uint256 _maxWithdrawLimit) external onlyOwner {
        users[_user] = _maxWithdrawLimit;
    }

    function deposit() external payable {}

    function withdraw(uint256 _amount) external {
        if (msg.sender != owner) {
            require(_amount <= users[msg.sender], "Amount over the withdraw limit");
        }
        users[msg.sender] -= _amount; 
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
