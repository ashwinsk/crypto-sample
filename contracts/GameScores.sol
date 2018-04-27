pragma solidity ^0.4.10;
contract GameScores {

    address public ceoAddress;

    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }
    
    function GameScores() public{
        ceoAddress = msg.sender;
    }

    event NewHighScore(address user, int256 score);

    uint8 maxTopScoreCount = 5;

    struct TopScore{
        address addr;
        int score;
    }

    TopScore[] public topScores;

    mapping (address => int256) public userToTopScore;

    function setTopScore(int256 score) public {
        
        var currentTopScore = userToTopScore[msg.sender];
        if(currentTopScore < score){
            userToTopScore[msg.sender] = score;
        }

        if(topScores.length < maxTopScoreCount){
            var topScore = TopScore(msg.sender, score);
            topScores.push(topScore);
            NewHighScore(msg.sender, score);
        }else{
            int lowestScore = 0;
            uint lowestScoreIndex = 0; 
            for (uint i = 0; i < topScores.length; i++)
            {
                TopScore currentScore = topScores[i];
                if(i == 0){
                    lowestScore = currentScore.score;
                    lowestScoreIndex = i;
                }else{
                    if(lowestScore > currentScore.score){
                        lowestScore = currentScore.score;
                        lowestScoreIndex = i;
                    }
                }
            }
            if(score > lowestScore){
                var newtopScore = TopScore(msg.sender, score);
                topScores[lowestScoreIndex] = newtopScore;
                NewHighScore(msg.sender, score);                
            }
        }
    }

    function getCountTopScores() constant public returns(uint) {
        return topScores.length;
    }

    function setMaxTopScoreCount(uint8 count) public{
        maxTopScoreCount = count;
    }

}