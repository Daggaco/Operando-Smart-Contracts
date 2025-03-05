// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => int256) private balances;
    mapping(address => uint256) private lastInterestUpdate;
    address public owner;
    uint256 public interestRate; // Interés en porcentaje (ej. 5 = 5%)

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event InterestUpdated(uint256 newRate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 _interestRate) {
        owner = msg.sender;
        interestRate = _interestRate;
    }

    function setInterestRate(uint256 _newRate) public onlyOwner {
        interestRate = _newRate;
        emit InterestUpdated(_newRate);
    }

    function applyInterest(address account) private {
        uint256 timeElapsed = block.timestamp - lastInterestUpdate[account];
        if (timeElapsed > 0) {
            uint256 interest = (uint256(balances[account]) * interestRate * timeElapsed) / (100 * 365 * 24 * 60 * 60);
            balances[account] += int256(interest);
            lastInterestUpdate[account] = block.timestamp;
        }
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        applyInterest(msg.sender);
        balances[msg.sender] += int256(msg.value);
        lastInterestUpdate[msg.sender] = block.timestamp;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        applyInterest(msg.sender);
        require(int256(amount) <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= int256(amount);
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid recipient address");
        applyInterest(msg.sender);
        applyInterest(recipient);
        require(int256(amount) <= balances[msg.sender], "Insufficient balance");
        
        balances[msg.sender] -= int256(amount);
        balances[recipient] += int256(amount);
        emit Transfer(msg.sender, recipient, amount);
    }

    function getBalance(address account) public view returns (int256) {
        return balances[account];
    }
}
