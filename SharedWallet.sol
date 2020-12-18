pragma solidity >=0.5.11 <0.7.0;

import "./Allowance.sol";
contract SharedWallet is Allowance {
    
   
    uint public balancerecieved;
    
    function recievemoney() public payable {
        balancerecieved = balancerecieved.add(msg.value);
    }
    
    event MoneySent(address indexed beneficiary,uint _amount);
    event MoneyRecieved(address indexed _from,uint _amount);
    
  
    function withdrawMoney(address payable _to, uint amount ) public ownerOrAllowance(amount){
        require(amount <= address(this).balance,"You do not have sufficient balance to withdraw Money");
        if(!isOwner()){
            reduceAllowance(msg.sender,amount);
        }
        emit MoneySent(_to,amount);
        _to.transfer(amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("Cannot renounceOwnership here");
    }
    
    fallback() external payable {
        emit MoneyRecieved(msg.sender,msg.value);
        recievemoney();
    }
}