// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract Funds {
    IERC20 public usdcToken;
    address public owner;
    uint256 public s_balances;
    mapping(address => uint256) public s_investmentAmount;

    constructor(address _owner, address _usdcToken) {
        owner = _owner;
        usdcToken = IERC20(_usdcToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /*@ dev investors deposit*/
    function deposit(uint256 amount) public {
        require(amount >= 25000 * 10 ** 18, "Minimum deposit not met");
        require(
            usdcToken.balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );
        s_investmentAmount[msg.sender] += amount;
        s_balances += amount;

        usdcToken.transferFrom(msg.sender, address(this), amount);
    }

    /*@ dev fund managers withdraw*/
    function withdrawFunds(uint256 amount) external onlyOwner {
        require(amount <= s_balances, "Insufficient funds");
        s_balances -= amount;
        // withdrawal logic here
    }

    function payInterestBasedOnInvestment() external onlyOwner {
        // profit distribution logic here
    }

    //@dev For receiving cash that's sent to this contract
    fallback() external payable {}

    receive() external payable {
        revert("Contract does not accept ETH");
    }
}
