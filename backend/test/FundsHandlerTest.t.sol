// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import "../script/DeployFundHandler.s.sol";
import {GreenInvest} from "../src/mainToken.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract CounterTest is Test {
    Funds funds;
    ERC20Mock usdcToken;
    GreenInvest greenToken;

    address public fundManager = makeAddr("123");

    address public user1 = makeAddr("234");
    address public user2 = makeAddr("600");
    address public usdcAdmin = makeAddr("500");

    uint256 public amountDeposited = 8e18;
    uint256 public mintAmount = 30e18;

    function setUp() public {
        usdcToken = new ERC20Mock();
        greenToken = new GreenInvest(fundManager, 40e18);
        funds = new Funds(fundManager, address(usdcToken), address(greenToken));
        vm.prank(user1);
        usdcToken.mint(user1, mintAmount);
    }

    function test_CanDeposit() public {
        vm.startPrank(user1);

        usdcToken.approve(address(funds), amountDeposited);
        funds.deposit(ERC20Mock(usdcToken), amountDeposited);
        funds.getTotalInvestorsBalance();
        funds.getInvestorAmount(user1);
        vm.stopPrank();
    }
}
