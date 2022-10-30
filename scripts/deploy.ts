import { run, ethers } from "hardhat";
import { IERC20__factory } from "../typechain-types";

async function main() {
  await run("compile");
  const ERC20 = await ethers.getContractFactory("PXR3");
  const contract = await ERC20.deploy("PXR3", "PXR", 18);

  await contract.deployed();

  console.log(`Contract for PXR3 token deployed \n
  Contract address: ${contract.address}`)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
