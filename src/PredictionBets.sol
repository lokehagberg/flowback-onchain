// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './Prediction.sol';


library ReduceBytes {
   struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
        // PollPhase phase;
    }
}

contract PredictionBets is Predictions{

     using ReduceBytes for *;

    // struct PredictionBet{
    //     uint pollId;
    //     uint proposalId;
    //     uint predictionId;
    //     bool bet;
    //     uint likelihood;
    //     PollPhase phase;
    // }

    mapping(uint => ReduceBytes.PredictionBet[]) public predictionBets;
    // event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    function _requireExist(uint _pollId, uint _proposalId, uint _predictionId) private view {
        require(requirePredictionToExist(_pollId, _proposalId, _predictionId), "Prediction does not exist");
    }

    modifier requireExist(uint _pollId, uint _proposalId,uint _predictionId){
        _requireExist(_pollId, _proposalId, _predictionId);
        _;
    }

    function placePredictionBet(
        uint _pollId,
        uint _proposalId,
        uint _predictionId,
        uint _likelihood,
        bool _bet
    )  external requireExist(_pollId, _proposalId, _predictionId){
        // bool rightPhase = predictions[_proposalId][_predictionId].phase == PollPhase.predictionBetPhase;
        //     require(rightPhase, "You can not bet at this time");
        // require(!predictionFinished, "Prediction is finished");
       // require(requirePredictionToExist(_pollId, _proposalId, _predictionId), "Prediction does not exist");
        // require(_likelihood > 0 , "Value needs to be between 0-1");

        //phases
            //  if (predictions[_proposalId][_predictionId-1].phase == PollPhase.predictionBetPhase) {
                    predictionBets[_predictionId-1].push(ReduceBytes.PredictionBet({
                        pollId: _pollId,
                        proposalId: _proposalId,
                        predictionId: _predictionId,
                        likelihood: _likelihood,
                        bet: _bet
                        // phase: PollPhase.completedPhase

                    }));
            // }

            // emit PredictionBetCreated(_predictionId, _bet, _likelihood);
    }

    function getPredictionBets(uint _pollId, uint _proposalId, uint _predictionId) external requireExist(_pollId, _proposalId, _predictionId) view returns(ReduceBytes.PredictionBet[] memory) {
        //require(requirePredictionToExist(_pollId, _proposalId, _predictionId));

        uint proposalsLength = proposals[_pollId].length;
        for (uint a=0; a <= proposalsLength;){
            if(proposals[_pollId][a].proposalId == _proposalId){
                uint predictionsLength =predictions[_proposalId].length;
                for (uint b=0; b <= predictionsLength;){
                    if(predictions[_proposalId][b].predictionId == _predictionId)
                        return predictionBets[_predictionId];
                    unchecked {
                        ++b;
                    }
                }
            }
            unchecked {
                ++a;
            }
        }
        return new ReduceBytes.PredictionBet[](0);
    }

    function requirePredictionToExist(uint _pollId, uint _proposalId, uint _predictionId) internal view returns (bool){

        uint proposalsLength = proposals[_pollId].length;
        for (uint a=0; a <= proposalsLength;){
            if (proposals[_pollId][a].proposalId ==_proposalId){
                uint predictionsLength = predictions[_proposalId].length;
                for (uint b=0; b <= predictionsLength;){
                    if (predictions[_proposalId][b].predictionId ==_predictionId)
                        return true;
                        unchecked {
                            ++b;
                        }
                }
                // return false;
            }
            unchecked {
            ++a;
            }
        }
        return false;
    }

}