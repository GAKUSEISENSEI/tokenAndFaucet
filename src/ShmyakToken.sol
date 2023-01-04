// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ShmyakToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint public blockReward;
    constructor(uint256 cap, uint reward) ERC20("ShmyakToken", "SHMK") ERC20Capped(cap * (10 ** 18)){
        owner = payable(msg.sender);
        _mint(owner, 7000000 * (10 ** 18));
        blockReward = reward * (10 ** 18);

    }

    function _mint(address account, uint256 amount) internal virtual override (ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
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
        require(msg.sender == owner, "You`re not an owner!");
        _;
        
    }

    function destroy() public onlyOwner{
        selfdestruct(owner);
    }
}

