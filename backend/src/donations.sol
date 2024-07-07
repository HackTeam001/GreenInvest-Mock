// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract Donations {
    using SafeERC20 for IERC20;

    event FundsDeposited(address indexed donator, uint256 indexed _amount);

    IERC20[] public tokenAddresses;
    address public fundManager;

    uint256 public s_balances;
    mapping(address donator => uint256 amountDonated) s_amountDonatedByInvestor;

    //functionality for adding only specific token addresses.
    //Can be many
    constructor(address _fundManager, IERC20[] memory _tokenAddresses) {
        fundManager = _fundManager;
        tokenAddresses = _tokenAddresses;
    }

    //action taken by only the fund manager
    modifier onlyfundManager() {
        require(msg.sender != address(0), "Not fundManager");
        require(msg.sender == fundManager, "Not fundManager");
        _;
    }

    /* through the allowed addys
    function deposit(uint256 amount, address tokenAddress) external {
        require(
            //tokenAddress.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );
        emit FundsDeposited(msg.sender, amount);
        s_amountDonatedByInvestor[msg.sender] += amount;
        s_balances += amount;
        tokenAddress.safeTransferFrom(msg.sender, address(this), amount);
    }*/
}
