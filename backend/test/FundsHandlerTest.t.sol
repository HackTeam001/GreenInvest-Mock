// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import "../script/DeployFundHandler.s.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract TestUSDC is ERC20, Ownable {
    constructor(
        address initialfundManager
    ) ERC20("USD Coin", "USDC") Ownable(initialfundManager) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

interface usdc {
    function mint(address to, uint256 amount) external;
}

contract CounterTest is Test {
    Funds public funds;
    TestUSDC public usdcToken;
    MyNFT public nft;

    address public fundManager = makeAddr("123");

    address public user1 = makeAddr("234");
    address public user2 = makeAddr("600");
    address public usdcAdmin = makeAddr("500");

    uint256 public amountDeposited = 12e18;
    uint256 public mintAmount = 20e18;

    function setUp() public {
        usdcToken = new TestUSDC(usdcAdmin);

        nft = new MyNFT(fundManager); // Assuming MyNFT contract requires the same fund manager as Funds contract

        funds = new Funds(fundManager, address(usdcToken));
        vm.prank(usdcAdmin);
        usdcToken.mint(user1, mintAmount);
    }

    function test_CanDeposit() public {
        vm.prank(user1);
        funds.deposit(TestUSDC(usdcToken), user1, amountDeposited);
    }
}
