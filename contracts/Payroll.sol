pragma solidity ^0.4.14;
// lesson 3
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    mapping(address => Employee) public employees;
    uint totalSalary=0;
    

    modifier employeeExist (address employeeId) {
      var employee = employees[employeeId];
      assert(employee.id != 0x0);
      _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }
    
   
    
  function addEmployee(address employeeId, uint salary) onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id == 0x0);
      employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
      totalSalary += salary * 1 ether;

  }

  function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

  function addFund() payable returns(uint){
      return this.balance;  // `this` is an address type
  }
  function getBalance() returns(uint){
        return this.balance;
    }

  function calculateRunway() returns(uint){
    return this.balance / totalSalary;
  }

  function hasEnoughFund() returns(bool){
    return calculateRunway() > 0;
  }

  function changePaymentAddress(address newAddress) employeeExist(msg.sender) {
      var employee = employees[msg.sender];
      employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
      delete employees[msg.sender];
  }

  function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
      var employee = employees[employeeId];
      assert(employee.id != 0x0);
      
      _partialPaid(employee);
      employees[employeeId] = Employee(employeeId, salary, now);
  }
  
  function getPaid() employeeExist(msg.sender){ 
    var employee = employees[msg.sender];
    uint nextPayDay = employee.lastPayday.add(payDuration);
    assert(nextPayDay < now);
    employee.lastPayday = nextPayDay;
    employee.id.transfer(employee.salary);
  }
}