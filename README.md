# Utility Contracts

This is a collection of utility contracts that we're using for dethlify.com. The point of the contracts is to minimize the amount of web3 calls to get blockchain data.

This is inspired by [@henrynguyen5](https://github.com/henrynguyen5).

The utils contract was deployed across all testnets **at the same address**. Get the minified abi at `Utils.json`.

Current version: `0xA1e92AF652Da241C89A345DdDe46522b4caf7fb5`

## Compound

### cToken balances + underlying balances

Quickly get both the underlying asset balance and balance of the cToken for a number of cTokens. This is great if you want to quickly check what kind of cTokens someone already owns.

```javascript
// using ethers.js
const Utils = require("Utils.json");
let address = "0xA1e92AF652Da241C89A345DdDe46522b4caf7fb5";
let utils = new ethers.Contract(address, Utils.abi, provider);
let cTokens = [
  "0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5",
  "0xf5dce57282a584d2746faf1593d3121fcac444dc",
  "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643",
  "0x39aa39c021dfbae8fac545936693ac917d5e7563",
  "0x6c8c6b02e7b2be14d4fa6022dfd6d75921d90e4e",
  "0x158079ee67fce2f58472a96584a73c7ab9ac95c1",
  "0xb3319f5d18bc0d84dd1b4825dcde5d5f7266d407",
  "0xc11b1268c1a384e55c48c2391d8d480264a3a7f4",
];
let owner = "0xdB39164d94E1C9AB6343FFDafaf4D05D4701Af95";
let result = await utils.getCompoundBalances.call(cTokens, owner);
let balances = result["0"];
let underlying = result["1"];
```

### Quick APY calculations

Use this if you want to quickly calculate the APY values of all cTokens.


```javascript
// ...
let supplyRates = await utils.getSupplyRates.call(cTokens);
let apies = [];
for(let i = 0; i < supplyRates.length; i++) {
  apies[i] = (supplyRates[i] * 2102400) / 1e18;
}
```


## ERC20 / ETH balances


```javascript
// using ethers.js
const Utils = require("Utils.json");
let utils = new ethers.Contract(Utils.abi, address, provider);
let tokens = [
  "0x0000000000000000000000000000000000000000", // for ETH
  "0x...",
  ...
];
let owner = "0x...";
let balances = await utils.getERC20Balances.call(tokens, owner);
```
