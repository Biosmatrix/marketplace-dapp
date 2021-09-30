// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Escrow is Ownable {
    using SafeMath for uint256;
    using Address for address payable;

    uint256 amount;

    address payable public payee;

    mapping(address => uint256) public deposits;

    event FundsDeposited(address indexed payee, uint256 value);
    event FundsReleased(address indexed payee, uint256 value);
    event FundsRefunded(address indexed payee, uint256 value);

    modifier onlyExactAmount(uint256 _amount) {
        require(_amount == getDepositAmount(), "Amount needs to be exact.");
        _;
    }

    function init(address payable _payee, uint256 _amount) public {
        payee = _payee;
        amount = _amount;
    }

    function getDepositAmount() public view returns (uint256) {
        return amount;
    }

    function deposit() public payable onlyExactAmount(msg.value) {
        emit FundsDeposited(msg.sender, msg.value);
    }

    function refund() public {
        uint256 payment = deposits[payee];

        deposits[payee] = 0;

        payee.transfer(payment);

        emit FundsRefunded(payee, payment);
    }

    function releaseFunds() external {
        uint256 payment = deposits[payee];

        deposits[payee] = 0;

        payee.transfer(payment);

        emit FundsReleased(payee, payment);
    }
}
