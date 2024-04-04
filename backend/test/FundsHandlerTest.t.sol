// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import "../script/DeployFundHandler.s.sol";

contract CounterTest is Test {
    Funds public funds;
    IERC20 public usdcToken;
    MyNFT public nft;

    address public fundManager = makeAddr("123");

    function setUp() public {
        nft = new MyNFT(fundManager);
        funds = new Funds(fundManager, address(usdcToken), address(nft));
    }
}
