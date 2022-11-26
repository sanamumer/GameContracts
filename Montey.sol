//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.11;
import './TRC20.sol';

contract Montey is TRC20{

    struct monteyhall{
        // uint256 deposit = 1000000 sun;
        uint8 doorNo;
        bool doorSelect;
        uint8 winDoor;
  
    }
    mapping (address => monteyhall)private Choice;

    uint8 private randomFactor;
 
    event newgameSet(address player,uint8 doorNo);
    event GameResult(address player, uint8 currentBet, uint8 winDoor);
    
    function SetNewGame()public payable returns(uint8){
        require(msg.value>0,'Bid higher amount');
        require(Choice[msg.sender].doorSelect == false);
        Choice[msg.sender].doorSelect == true ;
        Choice[msg.sender].doorNo = random();
        randomFactor += Choice[msg.sender].doorNo;
        emit newgameSet((msg.sender),Choice[msg.sender].doorNo);
        return (Choice[msg.sender].doorNo);
            }
    
    function SelectWin()public returns(address,uint8,uint8){
        require(Choice[msg.sender].doorSelect == true,'place the bet');
        Choice[msg.sender].winDoor = random();
        randomFactor += Choice[msg.sender].winDoor;
        Choice[msg.sender].doorSelect = false;
        if(Choice[msg.sender].winDoor == Choice[msg.sender].doorNo){
            transfer(msg.sender,1000000);
            emit GameResult(msg.sender, Choice[msg.sender].doorNo, Choice[msg.sender].winDoor);
        }else{
            emit GameResult(msg.sender, Choice[msg.sender].doorNo, Choice[msg.sender].winDoor);
        }return((msg.sender, Choice[msg.sender].doorNo, Choice[msg.sender].winDoor));
    }
    function doorSelect() public view returns(bool){
        return Choice[msg.sender].doorSelect;
    }
    function random() private view returns (uint8) {
        uint256 blockValue = uint256(blockhash(block.number-1 + block.timestamp));
        blockValue = blockValue + uint256(randomFactor);
        return uint8(blockValue % 2) + 1;
   }
}