// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyNFT is ERC721, ERC721Burnable, Ownable {
    constructor(
        address initialfundManager
    ) ERC721("NFT_Token", "NTK") Ownable(initialfundManager) {}

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }
}

interface NFT {
    function safeMint(address to, uint256 tokenId) external;
}

contract Funds {
    using SafeERC20 for IERC20;

    event FundsDeposited(address investor, uint256 _amount);
    event FundsWithdrawn(uint256 _amount);
    event ProfitDistributed(address _investor, uint256 _profit);

    address public fundManager;
    IERC20 public usdcToken;

    MyNFT public nft;
    uint256 public tokenID;

    address[] public s_investors;
    mapping(address => bool) public isInvestor;
    mapping(address => uint256) public s_investmentAmount;
    uint256 public s_balances;

    constructor(
        address _fundManager,
        address _usdcToken,
        address _nftContract
    ) {
        fundManager = _fundManager;
        usdcToken = IERC20(_usdcToken);
        nft = MyNFT(_nftContract);
    }

    modifier onlyfundManager() {
        require(msg.sender != address(0), "Not fundManager");
        require(msg.sender == fundManager, "Not fundManager");
        _;
    }

    /*@ dev s_investors deposit, they get an NFT*/
    function deposit(uint256 amount) public {
        require(amount >= 25000 * 10 ** 18, "Minimum deposit not met");
        require(
            usdcToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        if (!isInvestor[msg.sender]) {
            s_investors.push(msg.sender);
            tokenID++;
            nft.safeMint(msg.sender, tokenID);
            isInvestor[msg.sender] = true;
        }

        emit FundsDeposited(msg.sender, amount);
        s_investmentAmount[msg.sender] += amount;
        s_balances += amount;
        usdcToken.safeTransferFrom(msg.sender, address(this), amount);
    }

    /*@ dev fund managers withdraw*/
    function withdrawFunds(uint256 amount) external onlyfundManager {
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
