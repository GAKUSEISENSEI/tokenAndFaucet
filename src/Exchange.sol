// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ShmyakToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Exchange {
    using SafeMath for uint;

    ShmyakToken public token;
    
    address public owner;

    uint public balanceETH;


    constructor(ShmyakToken _token) {
        owner = msg.sender;
        balanceETH = 0;
        token = _token;
    }

    function getBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }
    modifier onlyOwner() {
        require(msg.sender == owner,"Only the contract owner can call this function");
        _;
    }
    
    function depositETH() public payable onlyOwner{
        require(msg.value > 0, "Cannot deposit zero or negative");
        balanceETH = balanceETH.add(msg.value);
    }

    function exchangeETHForSHMK() public payable{
        require(msg.value > 0, "Cannot exchange zero or negative");
        require(msg.value.mul(token.balanceOf(address(this))).div(balanceETH) <= token.balanceOf(address(this)), "Cannot exchange more tokens than contract have");

        uint amountSHMK = msg.value.mul(token.balanceOf(address(this))).div(balanceETH);

        balanceETH = balanceETH.add(msg.value);

        token.transfer(msg.sender, amountSHMK);
        
    }


    function exchangeSHMKForETH(uint _amountSHMK) public payable{
        require(_amountSHMK > 0, "Cannot exchange zero or negative tokens");
        require(_amountSHMK.mul(balanceETH).div(token.balanceOf(address(this))) <= balanceETH, "Cannot exchange more tokens than you have");
        require(token.balanceOf(msg.sender) >= _amountSHMK, "You do not have enough SHMK");

        uint amountETH = _amountSHMK.mul(balanceETH).div(token.balanceOf(address(this)));

        token.approve(address(this), _amountSHMK);
        token.transferFrom(msg.sender, address(this), _amountSHMK);
        payable(msg.sender).transfer(amountETH);
        
        
        balanceETH = balanceETH.sub(amountETH);
    }
    function withdrawAll() internal onlyOwner{
        token.transfer(owner, token.balanceOf(address(this)));
    }
}