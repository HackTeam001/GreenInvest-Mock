// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

//Minted after initial investment. Investor can burn their nft at will
contract MyNFT is ERC721, ERC721Burnable, Ownable {
    constructor(
        address initialfundManager
    ) ERC721("NFT_Token", "NTK") Ownable(initialfundManager) {}

    function safeMint(address to, uint256 nftTokenId) public onlyOwner {
        _safeMint(to, nftTokenId);
    }
}

interface NFT {
    function safeMint(address to, uint256 nftTokenId) external;
}

contract Funds is MyNFT {
    using SafeERC20 for IERC20;

    event FundsDeposited(address indexed investor, uint256 indexed _amount);
    event FundsWithdrawn(uint256 indexed _amount);
    event ProfitDistributed(address indexed _investor, uint256 indexed _profit);
    event NFTBurned(address indexed investor, uint256 indexed tokenId);

    address public fundManager;
    IERC20 public usdcToken;

    MyNFT public nft;
    uint256 public nft_tokenID;

    address[] public s_investors;
    uint256 constant MINIMUM_INVESTMENT_AMOUNT = 25000 * 1e18; //$25k
    mapping(address => bool) public s_isInvestor;
    mapping(address => uint256) public s_investmentAmount;
    mapping(address => uint256) public s_investorToNFTTokenID;

    uint256 public s_balances;

    //@Dev IDK IF the constructor part of NFT is right. I added it bc I want investors to be able to use the burn function to burn their nft's. Is the implementetion correct?
    constructor(address _fundManager, address _usdcToken) MyNFT(_fundManager) {
        fundManager = _fundManager;
        usdcToken = IERC20(_usdcToken);
    }

    //action taken by only the fund manager
    modifier onlyfundManager() {
        require(msg.sender != address(0), "Not fundManager");
        require(msg.sender == fundManager, "Not fundManager");
        _;
    }

    /*@ dev s_investors deposit for the first time, 
    they have a minimal amount to deposit + they get an NFT*/
    function deposit(IERC20 usdc, uint256 amount) public payable {
        require(usdc == usdcToken, "Token not allowed");
        require(
            usdcToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        if (!s_isInvestor[msg.sender]) {
            require(
                amount >= MINIMUM_INVESTMENT_AMOUNT,
                "Minimum deposit not met"
            );
            s_investors.push(msg.sender);
            nft_tokenID++;
            s_investorToNFTTokenID[msg.sender] = nft_tokenID;
            nft.safeMint(msg.sender, nft_tokenID);
            s_isInvestor[msg.sender] = true;
        }

        emit FundsDeposited(msg.sender, amount);
        s_investmentAmount[msg.sender] += amount;
        s_balances += amount;
        usdc.safeTransferFrom(msg.sender, address(this), amount);
    }

    // Check if the caller owns the token
    function _isApprovedOwner(uint256 tokenId) public view returns (bool) {
        require(s_isInvestor[msg.sender], "Only investors can burn their nft");
        require(
            s_investorToNFTTokenID[msg.sender] == tokenId,
            "TokenID doesnt match"
        );
        return true;
    }

    function burnToken(uint256 tokenId) external {
        // Check if the caller owns the token
        require(
            _isApprovedOwner(tokenId) == true,
            "ERC721Burnable: caller is not owner"
        );
        emit NFTBurned(msg.sender, tokenId);
        _burn(tokenId);
    }

    /*@ dev Only fund managers can withdraw. Should add multisig functionality*/
    function withdrawFunds(uint256 amount) external payable onlyfundManager {
        require(amount <= s_balances, "Insufficient funds");

        emit FundsWithdrawn(amount);
        s_balances -= amount;
        usdcToken.safeTransfer(msg.sender, amount);
    }

    function payInterestBasedOnInvestment(
        uint256 amount
    ) external onlyfundManager {
        require(amount <= s_balances, "Insufficient funds");

        for (uint256 i = 0; i < s_investors.length; i++) {
            address investor = s_investors[i];
            uint256 totalAmountInvested = s_investmentAmount[investor];
            uint256 profit = (totalAmountInvested * amount) / s_balances;

            emit ProfitDistributed(investor, profit);
            s_balances -= profit;
            s_investmentAmount[investor] -= profit;
            usdcToken.safeTransfer(investor, profit);
        }
    }

    //@dev For receiving cash that's sent to this contract
    fallback() external payable {}

    receive() external payable {
        revert("Contract does not accept ETH");
    }
}
