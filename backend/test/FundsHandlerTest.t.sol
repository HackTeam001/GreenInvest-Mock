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
    ERC20Mock wethToken;
    GreenInvest greenToken;

    address public fundManager = makeAddr("123");

    address public user1 = makeAddr("234");
    address public user2 = makeAddr("600");
    address public user3 = makeAddr("900");

    uint256 public amountDeposited = 15e18;
    uint256 public mintAmount = 30e18;

    function setUp() public {
        usdcToken = new ERC20Mock();
        wethToken = new ERC20Mock();
        greenToken = new GreenInvest(fundManager, 40e18);
        funds = new Funds(fundManager, address(usdcToken), address(greenToken));
        vm.prank(user1);
        wethToken.mint(user1, mintAmount);
        usdcToken.mint(user1, mintAmount);

        usdcToken.mint(user2, mintAmount);
        usdcToken.mint(user3, mintAmount);
    }

    modifier deposit() {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), amountDeposited);
        funds.deposit(ERC20Mock(usdcToken), amountDeposited);
        _;
    }

    function test_CanDeposit() public deposit {
        assertEq(funds.getTotalInvestorsBalance(), amountDeposited);
        assertEq(funds.getInvestorAmount(user1), amountDeposited);
    }

    function testFailIncorrectTokenAddress() public {
        vm.startPrank(user2);
        wethToken.approve(address(funds), amountDeposited);
        funds.deposit(ERC20Mock(usdcToken), amountDeposited);
    }

    function testErrorIncorrectAddress() public {
        vm.startPrank(user1);
        wethToken.approve(address(funds), amountDeposited);
        vm.expectRevert(bytes("Token not allowed"));
        funds.deposit(ERC20Mock(wethToken), amountDeposited);
    }

    function testFailDepositLowFunds() public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        funds.deposit(ERC20Mock(usdcToken), 5e18);
    }

    function testErrorLowFunds() public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        vm.expectRevert(bytes("Minimum deposit not met"));
        funds.deposit(ERC20Mock(usdcToken), 5e18);
    }

    function testReturningInvestorIsUpdated() public deposit {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        funds.deposit(ERC20Mock(usdcToken), 5e18);

        assertEq(funds.getTotalInvestorsBalance(), amountDeposited + 5e18);
        assertEq(funds.getInvestorAmount(user1), amountDeposited + 5e18);
    }
}
