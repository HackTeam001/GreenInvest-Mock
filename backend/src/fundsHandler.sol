// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*@dev This contract allows investors to send cash, manager to withdraw it & 
    send profits back to investers
       Profits will be distributed as per investment */

contract Funds {
    error notOwner();

    address public owner;
    uint256 public balances;
    mapping(address => uint256) public investmentAmount;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender != address(0), "Address doesn't exist");
        if (msg.sender != owner) {
            revert notOwner();
        }
        _;
    }

    /* @dev owner withdraws cash sent by investors in order to invest
     */
    function withdrawFunds(uint256 amount) external onlyOwner {}

    /* @dev owner sends investment proceeds to investors
     */
    function payInterestBasedOnInvestment() external onlyOwner {
        //(investment amount/total cash) * Total profits
    }

    //for receiving cash that's sent in this contract
    fallback() external payable {}

    receive() external payable {}
}
