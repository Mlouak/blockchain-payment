require('dotenv').config();
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const signer1 = process.env.SIGNER1_ADDRESS;
  const signer2 = process.env.SIGNER2_ADDRESS;

  if (!signer1 || !signer2) {
    throw new Error("Signers' addresses must be provided in the .env file");
  }

  // Deploy TenantContract
  const TenantContract = await ethers.getContractFactory("TenantContract");
  const tenantContract = await TenantContract.deploy([signer1, signer2], 2);
  await tenantContract.deployed();
  console.log("TenantContract deployed to:", tenantContract.address);

  // Deploy LandlordContract
  const LandlordContract = await ethers.getContractFactory("LandlordContract");
  const landlordContract = await LandlordContract.deploy([signer1, signer2], 2);
  await landlordContract.deployed();
  console.log("LandlordContract deployed to:", landlordContract.address);

  // Deploy TreasuryContract
  const TreasuryContract = await ethers.getContractFactory("TreasuryContract");
  const treasuryContract = await TreasuryContract.deploy([signer1, signer2], 2);
  await treasuryContract.deployed();
  console.log("TreasuryContract deployed to:", treasuryContract.address);

  // Deploy IssuanceContract
  const IssuanceContract = await ethers.getContractFactory("IssuanceContract");
  const issuanceContract = await IssuanceContract.deploy([signer1, signer2], 2);
  await issuanceContract.deployed();
  console.log("IssuanceContract deployed to:", issuanceContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
