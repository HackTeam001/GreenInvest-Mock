// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {GreenInvest} from "../src/mainToken.sol";

contract GreenToken is Script {
    function setUp() public {}

    function run() public {
        uint256 totalSupply = 21000000 * 10e18;
        address owner = makeAddr("1");
        GreenInvest token;

        uint256 privateKey = vm.envUint("DEV_PRIVATE_KEY ");
        address account = vm.addr(privateKey);
        console2.log("Account:", account);

        vm.startBroadcast(privateKey);
        token = new GreenInvest(owner, totalSupply);
    }
}
