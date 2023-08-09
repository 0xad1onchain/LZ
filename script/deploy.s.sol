// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";

import "src/CrossChainToken.sol";
import "src/ERC20Mintable.sol";

import {OFTV2} from "layerzerolabs/contracts/token/oft/v2/OFTV2.sol";



contract Deploy is Test {

    address public goerli_lzEndpoint = 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23;
    address public mumbai_lzEndpoint = 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8;

    uint16 public goerli_lzChainId = 10121;
    uint16 public mumbai_lzChainId = 10109;

    CrossChainToken proxyToken;
    ERC20Mintable innerToken;
    OFTV2 oftV2;
    function run() public {
        vm.startBroadcast();
        innerToken = new ERC20Mintable("InnerToken", "ITK", 8);
        innerToken.mint(address(0x45af3Bd5A2c60B7410f33C313c247c439b633446), 1000000000000000000000000000);

        proxyToken = new CrossChainToken(address(innerToken), 8, mumbai_lzEndpoint);
        innerToken.approve(address(proxyToken), 1000000000000000000000000000);
        

        vm.stopBroadcast();
    }

    function runDst() public {
        vm.startBroadcast();

        oftV2 = new OFTV2("GoerliInnerToken", "GITK", 8, goerli_lzEndpoint);

        address proxyTokenAddress = address(0xa6a8e6101cc11e864cf452f6BD6eeBb04C2756Aa);

        bytes memory srcPath = abi.encodePacked(proxyTokenAddress, address(oftV2));
        oftV2.setTrustedRemote(mumbai_lzChainId, srcPath);
        

        vm.stopBroadcast();
    }


}
