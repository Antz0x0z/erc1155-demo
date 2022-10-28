const hre = require("hardhat");

async function main() {

  const factory = await hre.ethers.getContractFactory("GameOfTheMind");
  const [owner] = await hre.ethers.getSigners();
  const contract = await factory.deploy();

  const stat = await contract.deployed();
  const t_minted = await stat.totalMinted(); 
  //const t_getData = await stat.getTokenId(); 
  //const t_owner = await stat.ownerOf(1);

  console.log("Contract deployed to: ", contract.address);
  console.log("Contract deployed by: ", owner.address, "\n");
  console.log("Total supply:\n ", t_minted);
  //console.log("Token #1 Owner:\n ", t_owner);
  //console.log("Token IDs & Holders:\n ", t_getData);
  console.log("Tokens have been minted successfully!");

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });