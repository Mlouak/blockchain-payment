// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSig.sol";

contract TenantContract is MultiSig {
    event RentPaid(address indexed tenant, uint amount, uint timestamp);

    constructor(address[] memory _signers, uint _requiredSignatures)
        MultiSig(_signers, _requiredSignatures)
    {}

    function payRent(bytes32 txHash, address payable landlord, uint amount) public payable {
        approveTransaction(txHash);
        if (approvals[txHash] >= requiredSignatures) {
            executeTransaction(txHash, landlord, amount);
            emit RentPaid(msg.sender, amount, block.timestamp);
        }
    }
}
