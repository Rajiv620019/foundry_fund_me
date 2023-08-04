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

    modifier fundedAmount() {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT}();
        _;
    }

    // Test funded address
    function testFundedAddressDataStructure() public fundedAmount {
        uint256 amountFunded = fundMe.getAddressToAmount(USER);
        assertEq(amountFunded, AMOUNT);
    }

    // Test funders to array of funders
    function testFundersToArrayOfFunders() public fundedAmount {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    // Only owner can withdraw
    function testOnlyOwnerCanWithdraw() public fundedAmount {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
}
