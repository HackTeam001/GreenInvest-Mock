// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
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
    IERC20 public immutable usdcToken; //that is deposited or used for investment

    GreenInvest public immutable greenTAddress; //minted as evidence tokens you've invested. Can be redeemed
    uint256 public constant RATE = 5e18; // Number of tokens per Ether. 1 ether:2 green tokens
    uint256 public constant PERCENTAGEE = 100; //conversions

    address[] public s_investors;
    mapping(address => bool) public s_isInvestor;
    mapping(address => uint256) public s_investmentAmount;
    mapping(address => uint256) public s_investorToGreenTokens;
    uint256 constant MINIMUM_INVESTMENT_AMOUNT = 10e18;

    uint256 public s_balances;
    uint256 public s_returns;

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

    // Check if the caller owns the token
    modifier _isApprovedOwner(uint256 amount) {
        require(
            s_isInvestor[msg.sender],
            "Only investors can burn their tokens"
        );
        require(
            s_investorToGreenTokens[msg.sender] <= amount,
            "Insufficient balance"
        );
        require(amount > 0, "No 0 burning allowed");
        _;
    }

    /*@ dev s_investors deposit for the first time, 
    they have a minimal amount to deposit + they get some greenTokens depending on their investment amount */
    function deposit(IERC20 usdc, uint256 amount) public payable nonReentrant {
        require(msg.sender != address(0), "Address 0 not allowed");
        require(usdc == usdcToken, "Token not allowed");
        require(amount > 0, "No 0 deposits allowed");
        // require(amount >= MINIMUM_INVESTMENT_AMOUNT, "Low investment amount");
        require(usdc.balanceOf(msg.sender) >= amount, "Insufficient balance");

        //new investor
        if (!s_isInvestor[msg.sender]) {
            require(
                amount >= MINIMUM_INVESTMENT_AMOUNT,
                "Minimum deposit not met"
            );
            emit newInvestorDeposit(msg.sender, amount);
            uint256 tokenAmount = amount / RATE;
            s_isInvestor[msg.sender] = true;
            s_investorToGreenTokens[msg.sender] = tokenAmount;
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;
            s_investors.push(address(msg.sender));

            usdc.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(msg.sender, tokenAmount);
        } else {
            //returning investor
            emit FundsDeposited(msg.sender, amount);
            uint256 tokenAmount = amount / RATE;
            s_investorToGreenTokens[msg.sender] += tokenAmount;
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;

            usdc.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(msg.sender, tokenAmount);
        }
    }

    //after a certain period of time
    function burnToken(uint256 amount) public _isApprovedOwner(amount) {
        uint256 tokenValue = amount * RATE;

        emit tokensBurned(msg.sender, amount);
        s_investmentAmount[msg.sender] -= amount;
        s_balances -= amount;

        greenTAddress.burn(amount);
        usdcToken.safeTransfer(msg.sender, tokenValue); //not sure
    }

    //People can withdraw investment after 2 years (mature investment)
    function WithdrawMatureInvestment(
        IERC20 usdc,
        uint256 amount
    ) external nonReentrant _isApprovedOwner(amount) {
        require(usdc == usdcToken, "Token not allowed");
        uint256 valueOfTokens = amount * RATE;

        if (s_investmentAmount[msg.sender] > 0) {
            s_balances -= valueOfTokens;
            s_investmentAmount[msg.sender] -= valueOfTokens;
            burnToken(amount);
            usdcToken.safeTransfer(msg.sender, valueOfTokens);
        }
        //.. remove them as investor
        else {
            s_isInvestor[msg.sender] = false;
            s_investmentAmount[msg.sender] -= valueOfTokens;
            s_balances -= valueOfTokens;
            // s_investors.pop(msg.sender); delete
        }
    }

    /*@ dev Only fund managers can withdraw. Should add multisig functionality*/
    function withdrawFunds(
        IERC20 usdc,
        uint256 amount
    ) external payable onlyfundManager {
        require(amount <= s_balances, "Insufficient funds");
        require(usdc == usdcToken, "Token not allowed");

        emit FundsWithdrawn(amount);
        s_balances -= amount;
        usdcToken.safeTransfer(msg.sender, amount);
    }

    //Payments of mature investments
    function payInterestBasedOnInvestment(
        uint256 _returns
    ) external onlyfundManager nonReentrant {
        for (uint256 i = 0; i < s_investors.length; i++) {
            address investor = s_investors[i];
            uint256 totalAmountInvested = s_investmentAmount[investor];

            uint256 profitPercentage = (totalAmountInvested / s_balances) * 100;
            s_returns = _returns;
            uint256 profit = s_returns * profitPercentage;

            emit ProfitDistributed(investor, profitPercentage);
            // s_balances -= totalAmountInvested;
            // s_investmentAmount[investor] -= totalAmountInvested;
            usdcToken.safeTransfer(investor, profit);
        }
    }

    //@DEV GETTER FUNCTIONS. USEFUL IN TESTS
    function getIsInvestor(address x) external view returns (bool) {
        return s_isInvestor[x];
    }

    /*  function getInvestor() external view returns (address) {
        uint256 length = s_investors.length;
        uint160 y = 1;
        for (uint160 i = y; i < length; i++) {
            if (msg.sender == s_investors[i]) {
                return s_investors[i];
            }
        }
    } */

    function getTotalInvestorsBalance() external view returns (uint256) {
        return s_balances;
    }

    function getInvestorAmount(
        address investor
    ) external view returns (uint256) {
        return s_investmentAmount[investor];
    }

    function getInvestorToGreenTokens(
        address investor
    ) external view returns (uint256) {
        return s_investorToGreenTokens[investor];
    }

    //@dev For receiving any cash that's sent to this contract.
    fallback() external payable {}

    receive() external payable {}
}
