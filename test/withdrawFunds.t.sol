// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Malicious} from "src/malicious.sol";
import {Attacker} from "src/attacker.sol";

contract CounterTest is Test {
    Malicious malicious ; 
    Attacker attacker ;
    address user1 = makeAddr("user1");
    address user2  = makeAddr("user2");
    function setUp() external 
    {
        malicious = new Malicious();
        attacker = new Attacker(address(malicious));
        vm.deal(user1, 10 ether);
        vm.deal(user2, 1 ether);
    }

    function testCorrectDeploymentOfmalicious() public view 
    {
        assert(address(malicious) == address(attacker.malicious()));
    }
    function testDepositEtherInMalicious() public 
    {
        console.log("Before userBalance",user1.balance);
        vm.startPrank(user1);
        malicious.depositFunds{value: 8 ether}();
        vm.stopPrank();
        assert(user1.balance == 2 ether);
        assert(malicious.getUserBalance(user1) == 8 ether);
    }

    function testPerformingReenterancy() public {
       
        // funding the malicious one 
        vm.startPrank(user1);
        malicious.depositFunds{value: 8 ether}();
        vm.stopPrank();
        
        // performing the attack 
        vm.startPrank(user2);
        attacker.deposit{value:1 ether}();
        attacker.attack();
        vm.stopPrank();
        console.log("user2 balance",user2.balance);
        console.log("attacker contract", address(attacker).balance);
        console.log("malicious contract ",address(malicious).balance);
        console.log("withdraw", attacker.withdraw());
         console.log("count ", malicious.count());
    //    assert(address(attacker).balance == 9 ether);
    }

}
    