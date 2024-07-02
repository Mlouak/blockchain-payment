// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MultiSig.sol";

contract LandlordContract is MultiSig {
    event RentCollected(address indexed landlord, uint amount, uint timestamp);

    constructor(address[] memory _signers, uint _requiredSignatures)
        MultiSig(_signers, _requiredSignatures)
    {}

    function collectRent(bytes32 txHash, address payable landlord, uint amount) public {
        approveTransaction(txHash);
        if (approvals[txHash] >= requiredSignatures) {
            executeTransaction(txHash, landlord, amount);
            emit RentCollected(landlord, amount, block.timestamp);
        }
    }
}
