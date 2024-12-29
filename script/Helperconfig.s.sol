// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract Helperconfig is Script {

    netconfig public activenet;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct netconfig {
        address priceFeed;
    }

    constructor(){
        if(block.chainid==11155111){
            activenet=getSepoliaEth();
        }
        else{
            activenet=getorcreateAnvilEth();
        }
    }

    function getSepoliaEth() public pure returns(netconfig memory) {
        netconfig memory sepolianet = netconfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepolianet;
    }

    function getorcreateAnvilEth() public returns(netconfig memory){
        if(activenet.priceFeed != address(0)){
            return activenet;
        }

        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        netconfig memory anvilnet = netconfig({priceFeed:address(mockpricefeed)});
        return anvilnet;
    }
}