const ERC20Token = artifacts.require("ERC20Token");
const SupplyChain = artifacts.require("SupplyChain");

module.exports = function(deployer) {
    deployer.deploy(ERC20Token, 10000, 18, "BUV Token", "BUV");
    deployer.deploy(SupplyChain);
}