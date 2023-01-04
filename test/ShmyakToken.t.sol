// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {ShmyakToken} from "../src/ShmyakToken.sol";

contract ShmyakTokenTest is Test {
    ShmyakToken public token;
    function setUp() public {
        token = new ShmyakToken(10000000, 10);
 
    }
    function testToken() public {
       console.log("--------------------");
       console.log(token.balanceOf(msg.sender), msg.sender);
       console.log(token.balanceOf(token.owner()));
       console.log(token.owner(),address(this));
       console.log(address(token));
       console.log(token.balanceOf(address(token)));
       
        
    }

    function testTrancfer() public {
        token.transfer(address(msg.sender), 232323);
        testToken();

    }
}