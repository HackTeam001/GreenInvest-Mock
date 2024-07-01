// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Funds} from "../src/fundsHandler.sol";
import {GreenInvest} from "../src/mainToken.sol";

import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FundsScript is Script {
    function run() external returns (Funds) {
        address manager = makeAddr("123");
        IERC20 usdcToken;
        GreenInvest greenToken;
        Funds funds;
        // uint256 privateKey = vm.envUint("DEV_PRIVATE_KEY ");
        // address account = vm.addr(privateKey);
        //_boundconsole2.log("Account:", account);

        vm.startBroadcast();
        funds = new Funds(manager, address(usdcToken), address(greenToken));
        vm.stopBroadcast();
        return funds;
    }
}
