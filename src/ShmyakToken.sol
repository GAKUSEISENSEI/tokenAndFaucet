// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Exchange.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ShmyakToken is ERC20, ERC20Burnable {
    address  public owner;
    uint public blockReward;
    uint public _cap;
    Exchange public exchange;
    constructor() ERC20("ShmyakToken", "SHMK"){
        owner = msg.sender;
        _cap = 1000000;
        blockReward = 1;

    }

    function setExcAddress(Exchange _exchange) public onlyOwner{
        exchange = _exchange;
    }

    function _owner() public view returns (address){
        return owner;
    }

    function mint (address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function cap() public view returns(uint){
        return _cap;
    }

    function _mint(address account, uint256 amount) internal virtual override (ERC20) {
        require(ERC20.totalSupply() + amount <= _cap, "cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }
    function _beforeTokenTransfer(address from, address to, uint value) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint reward) public onlyOwner {
        blockReward = reward * (10 ** 18);
    }
    modifier onlyOwner {
        require(msg.sender == owner || msg.sender == address(exchange), "You`re not an owner!");
        _;
        
    }

    function destroy() public onlyOwner{
        selfdestruct(payable(owner));
    }
}

