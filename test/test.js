const ethers = require("ethers");
const Utils = artifacts.require("Utils");

const cTokens = [
  "0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5",
  "0xf5dce57282a584d2746faf1593d3121fcac444dc",
  "0x39aa39c021dfbae8fac545936693ac917d5e7563",
  "0x6c8c6b02e7b2be14d4fa6022dfd6d75921d90e4e",
  "0x158079ee67fce2f58472a96584a73c7ab9ac95c1",
  "0xb3319f5d18bc0d84dd1b4825dcde5d5f7266d407",
  "0xc11b1268c1a384e55c48c2391d8d480264a3a7f4",
];
const owner = "0x3a9F7C8cA36C42d7035E87C3304eE5cBd353a532";

contract("Utils", async () => {
  it("[UTILS] get some balances", async () => {
    let utils = await Utils.deployed();
    let result = await utils.getCompoundBalances.call(cTokens, owner);
    let balances = result["0"];
    let underlying = result["1"];

    for (let i = 0; i < balances.length; i++) {
      console.log(`[+] cToken balance:     ${ethers.utils.formatUnits(balances[i].toString(), 8)}`) // prettier-ignore
      console.log(`[+] underlying balance: ${ethers.utils.formatUnits(underlying[i].toString(), 18)}`) // prettier-ignore
    }
  });

  it("[UTILS] get supply rates", async () => {
    let utils = await Utils.deployed();

    let supplyRates = await utils.getSupplyRates.call(cTokens);

    let apies = [];
    for (let i = 0; i < supplyRates.length; i++) {
      apies[i] = ((supplyRates[i] * 2102400) / 1e18) * 100;
      console.log(`[+] supply apy of ${cTokens[i].substring(0, 5)} is ${Number(parseFloat(apies[i]).toFixed(3))}%`); // prettier-ignore
    }
  });

  it("[UTILS] get borrow rates", async () => {
    let utils = await Utils.deployed();

    let borrowRates = await utils.getBorrowRates.call(cTokens);

    let apies = [];
    for (let i = 0; i < borrowRates.length; i++) {
      apies[i] = ((borrowRates[i] * 2102400) / 1e18) * 100;
      console.log(`[+] borrow apy of ${cTokens[i].substring(0, 5)} is ${Number(parseFloat(apies[i]).toFixed(3))}%`); // prettier-ignore
    }
  });
});
