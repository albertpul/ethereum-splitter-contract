var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {
  
  var contract;
  var owner = accounts[0];  var initialBalanceOwner;
  var splitToA = accounts[1];  var initialBalanceSplitToA;
  var splitToB = accounts[2];  var initialBalanceSplitToB;
  var amountToSplit = web3.toWei(0.2,"ether");

  beforeEach( function(){
      return Splitter.new( splitToA, splitToB, {from : owner})
      .then( instance => contract = instance );
  });

  it("should be owned by owner", function(){
    return contract.owner( {from:owner})
    .then( _owner => {
        assert.strictEqual( _owner, owner, "Contract is not owned by owner");
    });
  });

  it("should have the correct split to addresses", function(){
    return contract.splitToAddressA( {from:owner})
    .then( function( _a) {
        assert.strictEqual( _a, splitToA, "Split A address is not correct");
        return contract.splitToAddressB( {from:owner})
    }).then( function( _b)  {
      assert.strictEqual( _b, splitToB, "Split B address is not correct");
    });
  });

  it("should split the transfer between the other two contracts", function(){
    initialBalanceSplitToA = web3.eth.getBalance(splitToA);
    initialBalanceSplitToB = web3.eth.getBalance(splitToB);

    return contract.split({from:owner, value: amountToSplit})
    .then( function(txSplit) {
      assert.equal(web3.eth.getBalance(splitToA).toNumber(), 
            initialBalanceSplitToA.toNumber() + amountToSplit*1/2,
            "Split account A Balance does not match");
      assert.equal(web3.eth.getBalance(splitToB).toNumber(), 
            initialBalanceSplitToB.toNumber() + amountToSplit*1/2,
            "Split account B Balance does not match");
    });
  });

  it("should emit Split event and include all 5 arguments", function(){
      return contract.split({from:owner, value: amountToSplit})
    .then( function(txSplit) {
      assert.equal(txSplit.logs.length,1, "Split Event not emitted");
      assert.strictEqual(txSplit.logs[0].event,"Split", "Event emitted is not Split");
      assert.strictEqual(txSplit.logs[0].args._from, owner, "Split Event _from argument not included or incorrect value");
      assert.strictEqual(txSplit.logs[0].args._toA, splitToA, "Split Event _toA argument not included or incorrect value");
      assert.strictEqual(txSplit.logs[0].args._toB, splitToB, "Split Event  _toB argument not included or incorrect value");
      assert.equal(txSplit.logs[0].args._value.toNumber(), amountToSplit*1, "Split Event  _value argument not included or incorrect value");
      assert.equal(txSplit.logs[0].args._valueSplit.toNumber(), amountToSplit*1/2, "Split Event _valueSplit argument not included or incorrect value");
    });
  });

});
