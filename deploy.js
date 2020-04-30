require("dotenv").config();
const Utils = require("./build/contracts/Utils.json");
const ethers = require("ethers");

let networks = ["mainnet", "ropsten", "rinkeby", "goerli", "kovan"];

async function deploy() {
  for (let i = 0; i < networks.length; i++) {
    let provider = new ethers.providers.InfuraProvider(
      networks[i],
      process.env.INFURA_PROJECT
    );
    let wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
    let utilsFactory = new ethers.ContractFactory(
      Utils.abi,
      Utils.bytecode,
      wallet
    );
    await utilsFactory.deploy();
    console.log(`[+] deploying on ${networks[i]}`);
  }
}

deploy();
