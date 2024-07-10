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
    mapping(address => bool) public s_IsGreenInvestor;
    mapping(address => address) public greenAddressToUSDC;

    mapping(address => uint256) public s_investmentAmount;
    mapping(address => uint256) public s_investorToGreenTokens;
    uint256 constant MINIMUM_INVESTMENT_AMOUNT = 10e18;

    uint256 public s_balances;
    uint256 public s_returns; //added to the contract

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
            amount <= s_investorToGreenTokens[msg.sender],
            "Insufficient balance"
        );
        require(amount >= 0, "No 0 burning allowed");
        _;
    }

    /*@ dev s_investors deposit for the first time, 
    they have a minimal amount to deposit + they get some greenTokens depending on their investment amount */
    function deposit(
        IERC20 usdc,
        address investorGreenAddy,
        uint256 amount
    ) public payable nonReentrant {
        require(msg.sender != address(0), "Address 0 not allowed");
        require(usdc == usdcToken, "Token not allowed");
        require(amount > 0, "No 0 deposits allowed");
        // require(amount >= MINIMUM_INVESTMENT_AMOUNT, "Low investment amount");
        require(
            usdcToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        //new investor
        if (
            !s_isInvestor[msg.sender] && !s_IsGreenInvestor[investorGreenAddy]
        ) {
            require(
                amount >= MINIMUM_INVESTMENT_AMOUNT,
                "Minimum deposit not met"
            );
            emit newInvestorDeposit(msg.sender, amount);
            uint256 tokenAmount = amount / RATE;
            s_balances += amount;
            s_investorToGreenTokens[msg.sender] = tokenAmount;
            s_investmentAmount[msg.sender] = amount;
            s_isInvestor[msg.sender] = true;
            greenAddressToUSDC[investorGreenAddy] = msg.sender;
            s_IsGreenInvestor[investorGreenAddy] = true;
            s_investors.push(address(msg.sender));

            usdcToken.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(investorGreenAddy, tokenAmount);
        } else {
            //returning investor
            emit FundsDeposited(msg.sender, amount);
            uint256 tokenAmount = amount / RATE;
            s_investorToGreenTokens[msg.sender] += tokenAmount;
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;

            usdcToken.safeTransferFrom(msg.sender, address(this), amount);
            greenTAddress.mint(investorGreenAddy, tokenAmount);
        }
    }

    //after a certain period of time
    /*function burnToken(
        GreenInvest greentoken,
        uint256 amount
    ) public _isApprovedOwner(amount) {
        require(greenTAddress == greentoken, "Token not allowed");
        uint256 tokenValue = amount * RATE;

        s_investmentAmount[msg.sender] -= tokenValue;
        s_balances -= tokenValue;
        s_investorToGreenTokens[msg.sender] -= amount;
        emit tokensBurned(msg.sender, amount);

        greenTAddress.burn(amount);
        usdcToken.safeTransferFrom(address(this), msg.sender, tokenValue); //not sure
    }*/

    //People can withdraw investment after 2 years (mature investment)
    function WithdrawMatureInvestment(
        address greenTokenAddy,
        uint256 greentokens
    ) external _isApprovedOwner(greentokens) {
        require(
            greenAddressToUSDC[greenTokenAddy] == msg.sender,
            "Token not allowed"
        );
        //burrrrn:
        if (s_investmentAmount[msg.sender] > 0) {
            uint256 amount = s_investmentAmount[msg.sender];
            uint256 tokens = s_investorToGreenTokens[msg.sender];
            delete s_investmentAmount[msg.sender];
            s_balances -= amount;
            s_isInvestor[msg.sender] = false;
            s_IsGreenInvestor[greenTokenAddy] = false;
            //they have investment
            emit tokensBurned(msg.sender, amount);

            greenTAddress.burn(tokens);
            usdcToken.safeTransferFrom(address(this), msg.sender, amount);
        }
        //.. remove them sas investor
        else {
            return;
        }
    }

    /*@ dev Only fund managers can withdraw. Should add multisig functionality*/
    function withdrawFunds(IERC20 usdc) external payable onlyfundManager {
        require(msg.value <= s_balances, "Insufficient funds");
        require(usdc == usdcToken, "Token not allowed");

        s_balances -= msg.value;
        emit FundsWithdrawn(msg.value);

        usdcToken.safeTransfer(msg.sender, msg.value);
    }

    //Payments of mature investments
    function payInterestBasedOnInvestment(
        uint256 _returns
    ) external onlyfundManager nonReentrant {
        uint256 length = s_investors.length;
        for (uint256 i = 0; i < length; i++) {
            address investor = s_investors[i];
            uint256 totalAmountInvested = s_investmentAmount[investor];

            uint256 profitPercentage = (totalAmountInvested / s_balances) * 100;
            s_returns = _returns;
            uint256 profit = s_returns * profitPercentage;
            s_returns -= profit;
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
