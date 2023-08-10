// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";

import "src/CrossChainToken.sol";
import "src/ERC20Mintable.sol";

import {OFTV2} from "layerzerolabs/contracts/token/oft/v2/OFTV2.sol";
import {ICommonOFT} from "layerzerolabs/contracts/token/oft/v2/ICommonOFT.sol";



contract Deploy is Test {

    uint8 public constant PT_DEPOSIT_TO_REMOTE_CHAIN = 1;
    uint64 public constant DST_GAS_FOR_CALL = 300000;

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

    function runPostBothDep() public {

        vm.startBroadcast();

        proxyToken = CrossChainToken(0xa6a8e6101cc11e864cf452f6BD6eeBb04C2756Aa);
        

        address dstOFTAddress = address(0xCa84F4Da475f77994eBA11492A29f8a5e66727d3);

        bytes memory dstPath = abi.encodePacked(address(dstOFTAddress), address(proxyToken));
        

        proxyToken.setTrustedRemote(goerli_lzChainId, dstPath);
        proxyToken.setMinDstGas(goerli_lzChainId, proxyToken.PT_SEND(), 225000);
        proxyToken.setUseCustomAdapterParams(true);

        vm.stopBroadcast();

    }

    function initSend() public {

        vm.startBroadcast();

        proxyToken = CrossChainToken(0xa6a8e6101cc11e864cf452f6BD6eeBb04C2756Aa);
        innerToken = ERC20Mintable(0x0B78050F847a35c076359Da636cD124F596838d4);

        // No need of transfer, contract has approval
        // innerToken.transfer(address(proxyToken), 100000000);

        // address of destination chain receiver contract
        address dstOFTAddress = address(0xCa84F4Da475f77994eBA11492A29f8a5e66727d3);

        // build adapter params for send packet + gas
        bytes memory adapterParams = abi.encodePacked(uint16(1), uint256(225000+300000));
        console.log('adapterParams');
        console.logBytes(adapterParams);
        // proxyToken.quoteForDeposit(goerli_lzChainId, 0x45af3Bd5A2c60B7410f33C313c247c439b633446, 100000000, adapterParams);

        // build payload for send packet
        bytes memory payload = abi.encode(PT_DEPOSIT_TO_REMOTE_CHAIN, 0x45af3Bd5A2c60B7410f33C313c247c439b633446);
        console.log('payload');
        console.logBytes(payload);

        // estimate fee for send payload
        (uint nativeFee, uint zroFee) = proxyToken.estimateSendAndCallFee(goerli_lzChainId, bytes32(bytes20(dstOFTAddress)), 100000000, payload, DST_GAS_FOR_CALL, false, adapterParams);
        console.log('nativeFee', nativeFee, 'zroFee', zroFee);

        // build common call params for send payload
        ICommonOFT.LzCallParams memory callParams = ICommonOFT.LzCallParams(payable(0x45af3Bd5A2c60B7410f33C313c247c439b633446), address(0), adapterParams);

        // Invoke send call with fees
        proxyToken.sendAndCall{value: nativeFee}(0x45af3Bd5A2c60B7410f33C313c247c439b633446, goerli_lzChainId, bytes32(bytes20(dstOFTAddress)), 100000000, payload, DST_GAS_FOR_CALL, callParams);
        

        vm.stopBroadcast();
    }


}
