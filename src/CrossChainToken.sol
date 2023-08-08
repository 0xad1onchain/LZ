// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ProxyOFTV2} from "layerzerolabs/contracts/token/oft/v2/ProxyOFTV2.sol";
import {BytesLib} from "layerzerolabs/contracts/util/BytesLib.sol";
import {IOFTReceiverV2} from "layerzerolabs/contracts/token/oft/v2/IOFTReceiverV2.sol";

contract CrossChainToken is ProxyOFTV2 { 

    constructor(address _token, uint8 _sharedDecimals, address _lzEndpoint) ProxyOFTV2( _token, _sharedDecimals, _lzEndpoint) {}

}
