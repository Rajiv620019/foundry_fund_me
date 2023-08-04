// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig public helperConfig;

    address USER = makeAddr("rajiv");
    uint256 constant AMOUNT = 0.1 ether;
    uint256 constant BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, BALANCE);
    }

    // Test owner
    function testOwnerMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // Testing min USD is $5
    function testMinUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Testing price feed version
    function testPriceFeedVersion() public {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4);
    }

    // If the value was empty? 0 ETH
    function noETHSent() public {
        vm.expectRevert();
        fundMe.fund();
    }

    // Test funded address
    function testFundedAddressDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT}();

        uint256 amountFunded = fundMe.getAddressToAmount(USER);
        assertEq(amountFunded, AMOUNT);
    }
}
