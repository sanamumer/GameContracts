//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.11;
import './TRC20.sol';

contract Game is TRC20{
   
   //1 TRX = 1000000 sun
    struct Bet{
        uint8 currentBet;  
        bool isBetSet;
        uint8 destiny;
    }
    mapping (address => Bet)private bets;
    uint8 private randomFactor;
 
    event newBetSet(address bidder,uint8 currentBet);
    event GameResult(address bidder, uint8 currentBet, uint8 destiny);
    
    // function transfer()external {
    //      token = TRC20(TNq5PbSssK5XfmSYU4Aox4XkgTdpDoEDiY);
    //     token.transfer(msg.sender,100);
    // }
    function getNewBet()public payable returns(uint8){
        require(msg.value>0,'Bid higher amount');
        require(bets[msg.sender].isBetSet == false);
        bets[msg.sender].isBetSet == true ;
        bets[msg.sender].currentBet = random();
        randomFactor += bets[msg.sender].currentBet;
        emit newBetSet((msg.sender),bets[msg.sender].currentBet);
        return bets[msg.sender].currentBet;
            }
    
    function roll()public returns(address,uint8,uint8){
        require(bets[msg.sender].isBetSet == true,'place the bet');
        bets[msg.sender].destiny = random();
        randomFactor += bets[msg.sender].destiny;
        bets[msg.sender].isBetSet = false;
        if(bets[msg.sender].destiny == bets[msg.sender].currentBet){
            transfer(msg.sender,1000000);
            emit GameResult(msg.sender, bets[msg.sender].currentBet, bets[msg.sender].destiny);
        }else{
            emit GameResult(msg.sender,bets[msg.sender].currentBet, bets[msg.sender].destiny);
        }return(msg.sender,bets[msg.sender].currentBet, bets[msg.sender].destiny);
    }
    function isBetSet() public view returns(bool){
        return bets[msg.sender].isBetSet;
    }
    function random() private view returns (uint8) {
        uint256 blockValue = uint256(blockhash(block.number-1 + block.timestamp));
        blockValue = blockValue + uint256(randomFactor);
        return uint8(blockValue % 5) + 1;
   }
}
 