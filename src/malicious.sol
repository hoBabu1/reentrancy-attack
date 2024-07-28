// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Malicious {
    error Malicious__AmountShouldBeGreaterThanZero();
    error Malicious__UserisHavingInsufficientBalance();
    error Malicious__TransferOfBalanceFailed();

    mapping(address => uint256) private s_userBalance;

    function depositFunds() public payable {
        s_userBalance[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 amount) public {
        if (amount == 0) {
            revert Malicious__AmountShouldBeGreaterThanZero();
        }
        if (s_userBalance[msg.sender] < amount) {
            revert Malicious__UserisHavingInsufficientBalance();
        }
        (bool success,) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert Malicious__TransferOfBalanceFailed();
        }
       s_userBalance[msg.sender] -= amount;
    }

    function getUserBalance(address user) external view returns (uint256) {
        return s_userBalance[user];
    }
}
