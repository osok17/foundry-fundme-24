// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";
import {depolyfundme} from "../script/depolyfundme.s.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract  Fundfundme is Script {
    uint256 constant send_value = 0.01 ether;

    function fundfundme(address mostrecentlydeploy)  public {
        vm.startBroadcast();
        FundMe(payable(mostrecentlydeploy)).fund{value:send_value}();
        vm.stopBroadcast();
        console.log("fund me with %s",send_value);
    }

    function run() external{
        address mostrecentlydeploy = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundfundme(mostrecentlydeploy);
    }
}

contract Withdrawfundme is Script{
    function withdrawfundme(address mostrecentlydeploy)  public {
        vm.startBroadcast();
        FundMe(payable(mostrecentlydeploy)).withdraw();
        vm.stopBroadcast();
    }

    function run() external{
        address mostrecentlydeploy = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        withdrawfundme(mostrecentlydeploy);
    }
}