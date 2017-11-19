var Payroll = artifacts.require("./Payroll.sol");
var ERROR = 'Error: VM Exception while processing transaction: invalid opcode';

contract('Payroll', function(accounts) {
  it("unittest for addEmployee", function() {
    // console.log(accounts);
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      assert.equal(employee[0], accounts[1], "Checking adding employee id matching");
      return employee;
    }).catch(function(err){
        assert.equal(err.toString(), ERROR);
    });
  });

  it("unittest for removeEmployee", function() {

    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      payrollInstance.addEmployee(accounts[2], 1, {from: accounts[0]});
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(employee) {
    //   console.log(employee);
      assert.equal(employee[0], accounts[2], "Checking adding employee correctly");
      payrollInstance.removeEmployee(accounts[2], {from: accounts[0]});
      return payrollInstance.employees.call(accounts[2]);
    }).then(function(employee) {
      console.log(employee[0]);
      assert.equal(employee[0], 0x0, "Checking removing employee correctly");
    });
  });

});
