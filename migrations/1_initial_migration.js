var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer, network, accounts) {
  console.log("network:", network);
  console.log("accounts:", accounts);

  for( var i = 0; i < accounts.length; i++){

      console.log("balance account[" + i + "]=" + web3.fromWei(web3.eth.getBalance(accounts[i]), "ether"));

  }
  deployer.deploy(Migrations);
};