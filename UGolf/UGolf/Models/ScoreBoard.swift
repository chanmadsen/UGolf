//
//  ScoreBoard.swift
//  UGolf
//
//  Created by Hyrum Glen Bateman on 9/20/21.
//

import Foundation

class ScoreBoard {
    var nineHoleGame : [Int]?
    var eighteenHoleGame: [Int]?
    let score : Int
    let isNineHoleGame : Bool
    var par : Int
    
    init(nineHoleGame : [Int]?, eighteenHoleGame : [Int]?, score : Int, isNineHoleGame : Bool, par : Int) {
        self.nineHoleGame = nineHoleGame
        self.eighteenHoleGame = eighteenHoleGame
        self.score = score
        self.isNineHoleGame = isNineHoleGame
        self.par = par
    }
}

struct ScoreBoardHolder {
    
    let finishedGameScoreBoard : [ScoreBoard]
    
}


