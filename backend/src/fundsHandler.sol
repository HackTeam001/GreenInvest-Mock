// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

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

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract Funds {
    address public fundManager;
    IERC20 public usdcToken;

    MyNFT public nft;
    uint256 public tokenID;

    address[] public s_investors;
    bool isInvestor = false;
    mapping(address => uint256) public s_investmentAmount;
    uint256 public s_balances;

    constructor(address _fundManager, address _usdcToken) {
        fundManager = _fundManager;
        usdcToken = IERC20(_usdcToken);
    }

    modifier onlyfundManager() {
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
        for (uint i = 0; i < s_investors.length; i++) {
            if (msg.sender == s_investors[i]) {
                isInvestor = true;
                break;
            }
        }
        if (!isInvestor) {
            s_investors.push(msg.sender);
            tokenID++;
            nft.safeMint(msg.sender, tokenID);
        }

        s_investmentAmount[msg.sender] += amount;
        s_balances += amount;

        usdcToken.transferFrom(msg.sender, address(this), amount);
    }

    /*@ dev fund managers withdraw*/
    function withdrawFunds(uint256 amount) external onlyfundManager {
        require(amount <= s_balances, "Insufficient funds");
        s_balances -= amount;
        // withdrawal logic here
    }

    function payInterestBasedOnInvestment() external onlyfundManager {
        // profit distribution logic here
    }

    //@dev For receiving cash that's sent to this contract
    fallback() external payable {}

    receive() external payable {
        revert("Contract does not accept ETH");
    }
}
