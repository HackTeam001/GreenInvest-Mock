// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {MyNFT, Funds} from "../src/fundsHandler.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FundsScript is Script {
    function setUp() public {}

    function run() public {
        address manager = makeAddr("123");
        IERC20 usdcToken;
        MyNFT nft;
        Funds funds;
        // uint256 privateKey = vm.envUint("DEV_PRIVATE_KEY ");
        // address account = vm.addr(privateKey);
        //_boundconsole2.log("Account:", account);
        uint256 amount = 1e18;

        vm.startBroadcast();
        nft = new MyNFT(manager); // Assuming MyNFT contract requires the same fund manager as Funds contract

        funds = new Funds(manager, address(usdcToken));
        funds.deposit(usdcToken, manager, amount);
        vm.stopBroadcast();
    }
}
