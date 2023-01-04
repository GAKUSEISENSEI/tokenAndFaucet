// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Exchange} from "../src/Exchange.sol";
import {ShmyakToken} from "../src/ShmyakToken.sol";

contract ExchangeTest is Test {
    Exchange public exchange;
    ShmyakToken public token;
    function setUp() public {
        exchange = new Exchange(token);

    }

    function testBuyTokens() public {
        exchange.buyTokens(address(1000000000000000000));
    }
}