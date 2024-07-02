// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSig {
    address[] public signers;
    mapping(address => bool) public isSigner;
    uint public requiredSignatures;
    mapping(bytes32 => uint) public approvals;

    event SignerAdded(address signer);
    event SignerRemoved(address signer);
    event TransactionApproved(address signer, bytes32 txHash);
    event TransactionExecuted(bytes32 txHash);

    constructor(address[] memory _signers, uint _requiredSignatures) {
        require(_signers.length >= _requiredSignatures, "Signers < required signatures");
        for (uint i = 0; i < _signers.length; i++) {
            signers.push(_signers[i]);
            isSigner[_signers[i]] = true;
            emit SignerAdded(_signers[i]);
        }
        requiredSignatures = _requiredSignatures;
    }

    modifier onlySigner() {
        require(isSigner[msg.sender], "Not signer");
        _;
    }

    function approveTransaction(bytes32 txHash) public onlySigner {
        require(approvals[txHash] < requiredSignatures, "Already executed");
        approvals[txHash]++;
        emit TransactionApproved(msg.sender, txHash);
    }

    function executeTransaction(bytes32 txHash, address payable to, uint amount) public onlySigner {
        require(approvals[txHash] >= requiredSignatures, "Not enough approvals");
        require(address(this).balance >= amount, "Insufficient balance");
        to.transfer(amount);
        emit TransactionExecuted(txHash);
    }
}
