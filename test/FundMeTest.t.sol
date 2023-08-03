// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
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
}
