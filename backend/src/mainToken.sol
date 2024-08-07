// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";

/*@dev This is the main token that can be purchased at DEX
      Will also have an overall DAO where users (INVESTORS), can suggest updates, features, etc.
      The tokens can be used for voting in the overall DAO.
 */
contract GreenInvest is ERC20, Ownable, ERC20Permit, ERC20Votes {
    constructor(
        address initialOwner,
        uint256 _totalSupply
    )
        ERC20("GreenInvest", "GRN")
        Ownable(initialOwner)
        ERC20Permit("GreenInvest")
    {
        _mint(address(this), _totalSupply * 10 ** decimals());
        _mint(initialOwner, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function balance() public view returns (uint256) {
        return balanceOf(address(this));
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    function nonces(
        address owner
    ) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
