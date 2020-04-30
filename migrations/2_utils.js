const Utils = artifacts.require("Utils");

module.exports = async (deployer) => {
  await deployer.deploy(Utils);
};
