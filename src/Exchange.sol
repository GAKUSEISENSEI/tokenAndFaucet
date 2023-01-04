// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ShmyakToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Exchange {
    using SafeMath for uint;

    ShmyakToken public token;
    
    address public owner;

    uint public balanceETH;
    uint public balanceSHMK;

    mapping(address => uint) public balances;


    constructor(ShmyakToken _token) {
        owner = msg.sender;
        balanceETH = 0;
        balanceSHMK = 0;
        token = _token;
    }

    
    modifier onlyOwner() {
        require(msg.sender == owner,"Only the contract owner can call this function");
        _;
    }


    function getBalanceOfToken() public view returns(uint){
        return balances[address(this)];
    }


    function depositETH() public payable onlyOwner{
        require(msg.value > 0, "Cannot deposit zero or negative");
        balanceETH = balanceETH.add(msg.value);
    }


    function depositSHMK(uint _amountSHMK) public onlyOwner{
        require(_amountSHMK > 0, "amount should be greater than 0");
        require(_amountSHMK < token.cap(), "amount should be less than general amount of tokens");
        token.mint(address(this), _amountSHMK);
        balanceSHMK = balanceSHMK.add(_amountSHMK);
        balances[address(this)] = balances[address(this)].add(_amountSHMK);
    }


    function getBalanceOfSender() public view returns(uint){
        return balances[msg.sender];
    }


    function getSHMKForETH() public payable{
        require(msg.value > 0, "Cannot exchange zero or negative");
        require(msg.value.mul(token.balanceOf(address(this))).div(balanceETH) <= token.balanceOf(address(this)), "Cannot exchange more tokens than contract have");
        uint amountSHMK = msg.value.mul(token.balanceOf(address(this))).div(balanceETH);
        balanceETH = balanceETH.add(msg.value);
        balanceSHMK = balanceSHMK.sub(amountSHMK);
        token.transfer(msg.sender, amountSHMK);
        balances[msg.sender] = balances[msg.sender].add(amountSHMK);
        balances[address(this)] = balances[address(this)].sub(amountSHMK);
        
    }


    function getETHForSHMK(uint _amountSHMK) public{
        require(_amountSHMK > 0, "Cannot exchange zero or negative tokens");
        require(_amountSHMK.mul(balanceETH).div(token.balanceOf(address(this))) <= balanceETH, "Cannot exchange more tokens than you have");
        require(token.balanceOf(msg.sender) >= _amountSHMK, "You do not have enough SHMK");
        uint amountETH = _amountSHMK.mul(balanceETH).div(token.balanceOf(address(this)));
        balanceETH = balanceETH.sub(amountETH);
        balanceSHMK = balanceSHMK.add(_amountSHMK);
        token.transfer(address(this), _amountSHMK);
        payable(msg.sender).transfer(amountETH);
        balances[msg.sender] = balances[msg.sender].sub(_amountSHMK);    
        balances[address(this)] = balances[address(this)].add(_amountSHMK);  
    }


    function withdrawAll() internal onlyOwner{
        token.transfer(owner, token.balanceOf(address(this)));
    }

}
