// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import {Helperconfig} from "./Helperconfig.s.sol";

contract depolyfundme is Script{
    function run() external returns (FundMe){

        Helperconfig helperconfig = new Helperconfig();
        address ethUsdPriceFeed = helperconfig.activenet();

        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}