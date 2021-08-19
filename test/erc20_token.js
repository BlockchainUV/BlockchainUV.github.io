const ERC20Token = artifacts.require("ERC20Token");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("ERC20Token", function (/* accounts */) {
  it("should assert true", async function () {
    await ERC20Token.deployed();
    return assert.isTrue(true);
  });
});
