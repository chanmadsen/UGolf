//
//  ScoreBoard.swift
//  UGolf
//
//  Created by Hyrum Glen Bateman on 9/20/21.
//

import Foundation
import CoreLocation

class ScoreBoard: Codable {
    let score : Int
    let location : String
    let timestamp : Date
    let uuid: String

    
    init(score : Int, location: String , timestamp: Date = Date(), uuid: String = UUID().uuidString) {
        self.score = score
        self.location = location
        self.timestamp = timestamp
        self.uuid = uuid

    }
}

extension ScoreBoard: Equatable {
    static func == (lhs: ScoreBoard, rhs: ScoreBoard) -> Bool {
        return  lhs.uuid == rhs.uuid
    }
    
    
}



