// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSig.sol";

contract TreasuryContract is MultiSig {
    event FundsWithdrawn(address indexed to, uint amount, uint timestamp);

    constructor(address[] memory _signers, uint _requiredSignatures)
        MultiSig(_signers, _requiredSignatures)
    {}

    function withdrawFunds(bytes32 txHash, address payable to, uint amount) public {
        approveTransaction(txHash);
        if (approvals[txHash] >= requiredSignatures) {
            executeTransaction(txHash, to, amount);
            emit FundsWithdrawn(to, amount, block.timestamp);
        }
    }
}
