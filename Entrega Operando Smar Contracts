// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => int256) private balances;
    address public owner;

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += int256(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(int256(amount) <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= int256(amount);
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid recipient address");
        require(int256(amount) <= balances[msg.sender] + 1000, "Transfer exceeds overdraft limit");
        
        balances[msg.sender] -= int256(amount);
        balances[recipient] += int256(amount);
        emit Transfer(msg.sender, recipient, amount);
    }

    function getBalance(address account) public view returns (int256) {
        return balances[account];
    }
}
