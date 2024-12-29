// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {depolyfundme} from "../../script/depolyfundme.s.sol";

contract fundmetest is Test{
    FundMe fundme;

    address user = makeAddr("user");
    uint256 constant send_value = 0.1 ether;
    uint256 constant balance = 10 ether;
    uint256 constant gas_price = 1;


    function setUp() external{
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        depolyfundme depolyFundMe = new depolyfundme();
        fundme=depolyFundMe.run();
        vm.deal(user,balance);
    }
    function testmindollar() public view {
        assertEq(fundme.MINIMUM_USD(),5e18);
    }
    function testifethenough()public{
        vm.expectRevert();
        fundme.fund();
    }
    function testfundupdate()public{
        vm.prank(user);
        fundme.fund{value:send_value}();
        uint256 amountfunded = fundme.getaddresstoamountfunded(user);
        assertEq(amountfunded,send_value);

    }
    function testaddfunder() public{
        vm.prank(user);
        fundme.fund{value:send_value}();
        address funder = fundme.getfunder(0);
        assertEq(funder,user);
    }

    modifier funded(){
        vm.prank(user);
        fundme.fund{value:send_value}();
        _;
    }

    function testonlyownercanwithdraw() public funded{
        vm.prank(user);
        vm.expectRevert();
        fundme.withdraw();

    }

    function testwithdrawsinglefunder() public funded{
        uint256 startbalance = fundme.getowner().balance;
        uint256 startfundmebalance = address(fundme).balance;

        vm.prank(fundme.getowner());
        fundme.withdraw();


        uint256 endbalance = fundme.getowner().balance;
        uint256 endfundmebalance = address(fundme).balance;
        assertEq(endfundmebalance,0);
        assertEq(startbalance+startfundmebalance,endbalance);
    }

    function testwithdrawmultiplefunder() public funded{
        uint160 numoffunder = 10;
        uint160 startfunderindex = 2;
        for(uint160 i = startfunderindex;i<numoffunder;i++){
            hoax(address(i),send_value);
            fundme.fund{value:send_value}();
        }

        uint256 startbalance = fundme.getowner().balance;
        uint256 startfundmebalance = address(fundme).balance;

        vm.startPrank(fundme.getowner());
        fundme.withdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assert(startbalance+startfundmebalance == fundme.getowner().balance);
    }

    function testwithdrawmultiplefundercheaper() public funded{
        uint160 numoffunder = 10;
        uint160 startfunderindex = 2;
        for(uint160 i = startfunderindex;i<numoffunder;i++){
            hoax(address(i),send_value);
            fundme.fund{value:send_value}();
        }

        uint256 startbalance = fundme.getowner().balance;
        uint256 startfundmebalance = address(fundme).balance;

        vm.startPrank(fundme.getowner());
        fundme.cheaperwithdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assert(startbalance+startfundmebalance == fundme.getowner().balance);
    }
}