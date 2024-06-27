// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {GreenInvest} from "./mainToken.sol";

//Minted after initial investment. Investor can burn their nft at will

contract Funds is ReentrancyGuard {
    using SafeERC20 for IERC20;

    event newInvestorDeposit(address indexed investor, uint256 indexed _amount);

    event FundsDeposited(address indexed investor, uint256 indexed _amount);
    event FundsWithdrawn(uint256 indexed _amount);
    event ProfitDistributed(address indexed _investor, uint256 indexed _profit);
    event tokensBurned(address indexed investor, uint256 indexed tokenId);

    address public fundManager;
    IERC20 public usdcToken;

    GreenInvest public greenTAddress;
    uint256 public rate = 1000; // Number of tokens per Ether

    address[] public s_investors;
    uint256 constant MINIMUM_INVESTMENT_AMOUNT = 6e18;
    mapping(address => bool) public s_isInvestor;
    mapping(address => uint256) public s_investmentAmount;
    mapping(address => uint256) public s_investorToGreenTokens;

    uint256 public s_balances;

    constructor(
        address _fundManager,
        address _usdcToken,
        address _tokenAddress
    ) {
        fundManager = _fundManager;
        usdcToken = IERC20(_usdcToken);
        greenTAddress = GreenInvest(_tokenAddress);
    }

    //action taken by only the fund manager
    modifier onlyfundManager() {
        require(msg.sender != address(0), "Not fundManager");
        require(msg.sender == fundManager, "Not fundManager");
        _;
    }

    /*@ dev s_investors deposit for the first time, 
    they have a minimal amount to deposit + they get some greenTokens depending on their investment amount */
    function deposit(
        IERC20 usdc,
        address x,
        uint256 amount
    ) public payable nonReentrant {
        require(x == msg.sender, "Uknown caller");
        require(x != address(0), "Not fundManager");

        require(usdc == usdcToken, "Token not allowed");
        require(
            usdcToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        //new investor
        if (!s_isInvestor[msg.sender]) {
            require(
                amount >= MINIMUM_INVESTMENT_AMOUNT,
                "Minimum deposit not met"
            );
            emit newInvestorDeposit(msg.sender, amount);
            uint256 tokenAmount = amount / rate;
            s_isInvestor[msg.sender] = true;
            s_investorToGreenTokens[msg.sender] = tokenAmount;
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;

            usdc.approve(address(this), amount);
            usdc.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(msg.sender, tokenAmount);
        } else {
            //returning investor
            emit FundsDeposited(msg.sender, amount);
            uint256 tokenAmount = amount / rate;
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;

            usdc.approve(address(this), amount);
            usdcToken.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(msg.sender, tokenAmount);
        }
    }

    // Check if the caller owns the token
    function _isApprovedOwner(uint256 amount) public view returns (bool) {
        require(
            s_isInvestor[msg.sender],
            "Only investors can burn their tokens"
        );
        require(
            s_investorToGreenTokens[msg.sender] <= amount,
            "Insufficient balance"
        );
        return true;
    }

    function burnToken(uint256 amount) external {
        // Check if the caller owns the token
        require(
            _isApprovedOwner(amount) == true,
            "ERC721Burnable: caller is not owner"
        );
        emit tokensBurned(msg.sender, amount);
        uint256 tokenValue = amount * rate;

        s_investmentAmount[msg.sender] -= amount;
        s_balances -= amount;

        greenTAddress.burn(amount);
        usdcToken.safeTransfer(msg.sender, tokenValue);
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

    receive() external payable {}

    function checkInvestor(address x) external view returns (bool) {
        return s_isInvestor[x];
    }

    function checkBalances() external view returns (uint256) {
        return s_balances;
    }
}
