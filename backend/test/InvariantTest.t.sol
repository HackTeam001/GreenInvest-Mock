// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import "../script/DeployFundHandler.s.sol";
import {GreenInvest} from "../src/mainToken.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {Handler} from "../test/Handler.t.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract CounterTest is Test {
    Funds funds;
    ERC20Mock usdcToken; //token used
    // ERC20Mock wethToken;
    GreenInvest greenToken; //our main token minted as a reward
    Handler handler;

    address public fundManager = makeAddr("123");

    address public user1 = makeAddr("234");
    address public user2 = makeAddr("600");
    address public user3 = makeAddr("900");
    address public greenTokenAddressForUser1 = makeAddr("20");

    uint256 public amountDeposited = 20e18;
    uint256 public mintAmount = 30e18;

    function setUp() public {
        greenToken = new GreenInvest(fundManager, 40e18);
        usdcToken = new ERC20Mock();
        //wethToken = new ERC20Mock();
        vm.prank(user1);
        //_sendLogPayloadwethToken.mint(user1, mintAmount);
        usdcToken.mint(user1, mintAmount);

        usdcToken.mint(user2, mintAmount);
        usdcToken.mint(user3, mintAmount);

        funds = new Funds(fundManager, address(usdcToken), address(greenToken));

        handler = new Handler(
            funds,
            fundManager,
            greenToken,
            usdcToken,
            user1,
            greenTokenAddressForUser1
        );

        bytes4[] memory selectors = new bytes4[](3); //our functions
        selectors[0] = handler.deposit.selector;
        selectors[1] = handler.withdrawByManager.selector;
        selectors[2] = handler.payInterestBasedOnInvestmentByManager.selector;
        // selectors[3] = handler.withdrawMatureInvestmentByUser.selector;
        //selectors[3] = handler.burnTokenByUser.selector;

        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectors})
        );
        targetContract(address(handler));
    }

    /*function statefulFuzz_testInvariantBreaks(uint256 _amount) public {
        console2.log(
            "Starting statefulFuzz_testInvariantBreaks with amount:",
            _amount
        );
        vm.startPrank(user1);
        uint256 balance = usdcToken.balanceOf(user1) - _amount;
        funds.deposit(usdcToken, _amount);
        console2.log(
            "Deposit completed. User balance:",
            usdcToken.balanceOf(user1)
        );
        vm.stopPrank();

        assertEq(usdcToken.balanceOf(user1), balance);
    }*/

    modifier deposit(address investorGreenAddy) {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), amountDeposited);
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, amountDeposited);
        _;
    }

    function test_NewUserCanDeposit(
        address investorGreenAddy
    ) public deposit(investorGreenAddy) {
        assertEq(funds.getTotalInvestorsBalance(), amountDeposited);
        assertEq(funds.getInvestorAmount(user1), amountDeposited);
    }

    /* function testFailIncorrectTokenAddress() public {
        vm.startPrank(user2);
        wethToken.approve(address(funds), amountDeposited);
        funds.deposit(ERC20Mock(usdcToken),  amountDeposited);
    }

    function testErrorIncorrectAddress() public {
        vm.startPrank(user1);
        wethToken.approve(address(funds), amountDeposited);
        vm.expectRevert(bytes("Token not allowed"));
        funds.deposit(ERC20Mock(wethToken), amountDeposited);
    } */

    function testFailDepositLowFunds(address investorGreenAddy) public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, 5e18);
    }

    function testErrorLowFunds(address investorGreenAddy) public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        vm.expectRevert(bytes("Minimum deposit not met"));
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, 5e18);
    }

    function testErrorZeroAmount(address investorGreenAddy) public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 0);
        vm.expectRevert(bytes("No 0 deposits allowed"));
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, 0);
    }

    function testErrorInsufficientDeposit(address investorGreenAddy) public {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 40e18);
        vm.expectRevert(bytes("Insufficient balance"));
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, 40e18);
    }

    function testReturningInvestorIsUpdated(
        address investorGreenAddy
    ) public deposit(investorGreenAddy) {
        vm.startPrank(user1);
        usdcToken.approve(address(funds), 5e18);
        funds.deposit(ERC20Mock(usdcToken), investorGreenAddy, 5e18);
        vm.stopPrank();

        assertEq(funds.getTotalInvestorsBalance(), amountDeposited + 5e18);
        assertEq(funds.getInvestorAmount(user1), amountDeposited + 5e18);
        assertEq(funds.getIsInvestor(user1), true);
        assertEq(funds.s_investorToGreenTokens(user1), 5);
    }

    function testWithdrawInvestmentByUser(
        uint256 value,
        address investorGreenAddy
    ) public deposit(investorGreenAddy) {
        vm.startPrank(user1);
        vm.assume(value > 0);
        funds.WithdrawMatureInvestment(investorGreenAddy, value);
        uint256 amount = funds.getInvestorToGreenTokens(user1) - value;
        console2.log(usdcToken.balanceOf(address(this)));
        assertEq(funds.getInvestorToGreenTokens(user1), amount);
        /* assertEq(funds.getInvestorAmount(user1), 10e18);
        assertEq(funds.s_balances(), 10e18);*/
    }
}
