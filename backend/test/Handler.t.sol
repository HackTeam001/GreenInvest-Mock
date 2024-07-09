// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import {GreenInvest} from "../src/mainToken.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    Funds funds;
    ERC20Mock mock;
    GreenInvest greenToken;
    address manager = makeAddr("hey");
    address user = makeAddr("brr");

    constructor(
        Funds _funds,
        address _manager,
        GreenInvest _greenToken,
        ERC20Mock _mock,
        address _user
    ) {
        funds = _funds;
        manager = _manager;
        mock = _mock;
        greenToken = _greenToken;
        user = _user;
    }

    function deposit(uint256 amount) external {
        uint256 _amount = bound(amount, 0, mock.balanceOf(user));
        //_amount2 = bound(_amount2, 0, mock.balanceOf(user2));
        vm.startPrank(user);
        vm.deal(user, _amount);

        mock.approve(address(funds), _amount);
        funds.deposit(mock, _amount);

        /*vm.startPrank(user);
        mock.approve(address(funds), _amount2);
        funds.deposit(mock, _amount2);*/
        vm.stopPrank();
    }

    function withdrawByManager() external {
        vm.startPrank(manager);
        funds.withdrawFunds(mock);
        vm.stopPrank();
    }

    function burnTokenByUser(uint256 _amount) external {
        vm.startPrank(user);
        funds.burnToken(mock, _amount);
        vm.stopPrank();
    }

    function withdrawMatureInvestmentByUser(uint256 _amount) external {
        vm.startPrank(user);
        funds.WithdrawMatureInvestment(mock, _amount);
        vm.stopPrank();
    }

    function payInterestBasedOnInvestmentByManager(uint256 _returns) external {
        vm.startPrank(manager);
        funds.payInterestBasedOnInvestment(_returns);
        vm.stopPrank();
    }
}
