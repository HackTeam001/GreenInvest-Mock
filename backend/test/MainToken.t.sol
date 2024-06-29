// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {GreenInvest} from "../src/mainToken.sol";

contract MainTokenTest is Test {
    address public owner = makeAddr("1234");
    GreenInvest public token;
    uint256 public totalSupply = 20000000e18;

    address public user1 = makeAddr("456");
    address public user3 = makeAddr("678");
    uint256 public amountMinted = 1000000e18;

    function setUp() public {
        token = new GreenInvest(owner, totalSupply);
    }

    function testOwnerCanMint() public {
        vm.prank(owner);
        token.mint(user1, amountMinted);
    }

    function testUserCanBurnTokens() public {
        vm.prank(owner);
        token.mint(user3, amountMinted);
        vm.prank(user3);
        token.burn(500000e18);
    }
}
