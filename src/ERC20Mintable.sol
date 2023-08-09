// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mintable is ERC20 { 

    uint8 internal  _decimals;
    constructor(string memory name, string memory symbol, uint8 decimal) ERC20(name, symbol) {
        _decimals = decimal;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function mint(address recipient, uint amount) public {
        _mint(recipient, amount);
    }

}
