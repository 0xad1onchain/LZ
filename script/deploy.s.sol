// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/CrossChainToken.sol";
import "src/ERC20Mintable.sol";

contract Deploy is Test {

    address public goerli_lzEndpoint = 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23;
    address public mumbai_lzEndpoint = 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8;

    CrossChainToken proxyToken;
    ERC20Mintable innerToken;

    function run() public {
        vm.startBroadcast();
        innerToken = new ERC20Mintable("InnerToken", "ITK", 8);
        innerToken.mint(address(0x45af3Bd5A2c60B7410f33C313c247c439b633446), 1000000000000000000000000000);

        innerToken.approve(address(proxyToken), 1000000000000000000000000000);
        
        proxyToken = new CrossChainToken(address(innerToken), 8, mumbai_lzEndpoint);

        vm.stopBroadcast();
    }


}
