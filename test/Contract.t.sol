// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/CrossChainToken.sol";
import "src/ERC20Mintable.sol";

contract TestContract is Test {

    address public goerli_lzEndpoint = 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23;
    address public mumbai_lzEndpoint = 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8;

    CrossChainToken proxyToken;
    ERC20Mintable innerToken;

    function setUp() public {
        innerToken = new ERC20Mintable("InnerToken", "ITK", 8);
        innerToken.mint(address(this), 1000000000000000000000000000);
        
        proxyToken = new CrossChainToken(address(innerToken), 8, mumbai_lzEndpoint);
    }

    function testBar() public {
        assertEq(uint256(1), uint256(1), "ok");
    }

    function testFoo(uint256 x) public {
        vm.assume(x < type(uint128).max);
        assertEq(x + x, x * 2);
    }
}
