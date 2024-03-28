// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Funds} from "../src/fundsHandler.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyNFT is ERC721, ERC721Burnable, Ownable {
    constructor(
        address initialfundManager
    ) ERC721("NFT_Token", "NTK") Ownable(initialfundManager) {}

    function safeMint(address to, uint256 nftTokenId) public onlyOwner {
        _safeMint(to, nftTokenId);
    }
}

contract CounterTest is Test {
    Funds public funds;
    IERC20 public usdcToken;
    MyNFT public nft;

    address public fundManager;

    function setUp() public {
        //funds = new Funds(fundManager, IERC20(usdcToken), MyNFT(nft));
    }
}