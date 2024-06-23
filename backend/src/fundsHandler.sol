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

    //onlyOwner
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
    uint256 constant MINIMUM_INVESTMENT_AMOUNT = 10e18;
    mapping(address => bool) public s_isInvestor;
    mapping(address => uint256) public s_investmentAmount;
    mapping(address => uint256) public s_investorToNFTTokenID;

    uint256 public s_balances;

    constructor(address _fundManager, address _usdcToken) MyNFT(_fundManager) {
        fundManager = _fundManager;
        usdcToken = IERC20(_usdcToken);
        nft = MyNFT(fundManager);
    }

    //action taken by only the fund manager
    modifier onlyfundManager() {
        require(msg.sender != address(0), "Not fundManager");
        require(msg.sender == fundManager, "Not fundManager");
        _;
    }

    /*@ dev s_investors deposit for the first time, 
    they have a minimal amount to deposit + they get an NFT*/
    function deposit(IERC20 usdc, address x, uint256 amount) public payable {
        require(x == msg.sender, "Uknown caller");
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

            emit FundsDeposited(msg.sender, amount);
            nft_tokenID++;
            s_investorToNFTTokenID[x] = nft_tokenID;
            nft.safeMint(x, nft_tokenID);
            s_isInvestor[x] = true;

            s_investmentAmount[x] += amount;
            s_balances += amount;
            usdc.safeTransferFrom(msg.sender, address(this), amount);
        } else {
            //returning investor
            emit FundsDeposited(msg.sender, amount);
            s_investmentAmount[msg.sender] += amount;
            s_balances += amount;
            usdc.safeTransferFrom(msg.sender, address(this), amount);
        }
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

    function checkInvestor(address x) external view returns (bool) {
        return s_isInvestor[x];
    }

    function checkBalances() external view returns (uint256) {
        return s_balances;
    }
}
