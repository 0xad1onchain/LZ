// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mintable is ERC20 { 

    uint8 internal  _decimals;
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol) {
        _decimals = decimals;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function mint(address recipient, uint amount) public {
        _mint(recipient, amount);
    }

}
