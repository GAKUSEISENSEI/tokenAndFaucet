// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;



interface IERC20 {

    function transfer(address to, uint amount) external view  returns (bool);
    function balanceOf(address account) external view  returns (uint);

    event Transfer(address indexed from, address indexed to, uint value);
        
}

contract Faucet {
    address payable owner;
    IERC20 public token;
    uint public withdrawAmount = 50 * (10**18);

    uint lockTime = 1 seconds;
    event Withdraw(address indexed to, uint indexed amount);
    event Deposit(address indexed from, uint indexed amount);

    mapping (address => uint) timer;
    constructor (address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestsTokens() public {
        require(msg.sender != address(0), "Invalid address");
        require(token.balanceOf(address(this)) >= withdrawAmount, "You`re asking too much");
        require(block.timestamp >= timer[msg.sender], "Wait a bit");
        timer[msg.sender] = block.timestamp + lockTime;
        token.transfer(msg.sender, withdrawAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    function getBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }

    function setWithdrawAmount(uint amount) public onlyOwner{
        withdrawAmount = amount * (10 ** 18);  
    }

    function setLockTime(uint amount) public onlyOwner{
        lockTime = amount * 1 minutes;
    }

    function withdraw() external onlyOwner{
        emit Withdraw(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));

    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You`re not an owner");
        _;
    }
}