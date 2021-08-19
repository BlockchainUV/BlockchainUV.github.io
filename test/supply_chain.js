const SupplyChain = artifacts.require("SupplyChain");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("SupplyChain", function (/*accounts*/) {
  it("should create a participant", async function () {
    let instance = await SupplyChain.deployed();
    
    let participantId = await instance.createParticipant("A", "passA", "Manufacturer", "0xAd42cE1963f3086eDc9F238286bF39C73329A26d");
    let participant = await instance.participants(0);

    assert.equal(participant[0], "A", "error: p0");
    assert.equal(participant[2], "Manufacturer", "error: p0");

    participantId = await instance.createParticipant("B", "passB", "Supplier", "0xCd5eC54954A021d80f2552B20AA5731895E6b697");
    participant = await instance.participants(1);

    assert.equal(participant[0], "B", "error: p1");
    assert.equal(participant[2], "Supplier", "error: p1");

    participantId = await instance.createParticipant("C", "passC", "Consumer", "0xA781aD69B4EB3B7A69e33E8cC424A6Dec9eaB51C");
    participant = await instance.participants(2);

    assert.equal(participant[0], "C", "error: p2");
    assert.equal(participant[2], "Consumer", "error: p2");

    //return assert.isTrue(true);
  });

  it("should return participant details", async function () {
    let instance = await SupplyChain.deployed();
    
    let participantDetails = await instance.getParticipantDetails(0);
    assert.equal(participantDetails[0], "A");

    participantDetails = await instance.getParticipantDetails(1);
    assert.equal(participantDetails[0], "B");

    participantDetails = await instance.getParticipantDetails(2);
    assert.equal(participantDetails[0], "C");

    //return assert.isTrue(true);
  });

  it("should create a product", async function () {
    let instance = await SupplyChain.deployed();
    
    let productId = await instance.createProduct(0, "prodABC", "100", "123", 11);
    let product = await instance.products(0);

    assert.equal(product[0], "prodABC");
    assert.equal(product[3], "0xAd42cE1963f3086eDc9F238286bF39C73329A26d");

    //return assert.isTrue(true);
  });

  it("should transfer a product", async function () {
    let instance = await SupplyChain.deployed();
    /*
    let transferEvent = SupplyChain.Transfer({prodId: 0}, {from: "0xAd42cE1963f3086eDc9F238286bF39C73329A26d"}, {fromBlock: 0, toBlock: 'latest'});

    transferEvent.watch(function(err, result) {
      if (err) {
          console.log(err);
          return;
      }
      console.log(result);
    });
    */
    let success = await instance.transferToParticipant(1, 0, {from: "0xAd42cE1963f3086eDc9F238286bF39C73329A26d"});
    assert.equal(success.receipt.status, true);

    success = await instance.transferToParticipant(2, 0, {from: "0xCd5eC54954A021d80f2552B20AA5731895E6b697"});
    assert.equal(success.receipt.status, true);

    //return assert.isTrue(true);
  });
});