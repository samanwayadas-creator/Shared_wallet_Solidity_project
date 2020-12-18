pragma solidity >=0.5.11 <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol"; //Owner features
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol"; //Saferty featues

contract Allowance is Ownable {
    using SafeMath for uint;
    event AllowanceChanged(address indexed _to, address indexed _from,uint _oldAmount,uint _newAmount);
    
    mapping (address => uint) public allowance;
    
    function isOwner() public view returns(bool){ //to check if owner
        return owner() == msg.sender;
    }
    
    
    function addAllowance(address _who,uint amount) public onlyOwner{//Owner can set the allowance limit
        emit AllowanceChanged(_who,msg.sender,allowance[_who],amount);
        allowance[_who] = amount; 
    }
    
    modifier ownerOrAllowance(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed"); //person is allowed only when they have sufficient balance to withdraw
        _;
    } 
    
    
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who,msg.sender,allowance[_who],allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
  
    
}