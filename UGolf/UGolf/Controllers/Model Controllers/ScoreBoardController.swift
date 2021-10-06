//
//  ScoreBoardController.swift
//  UGolf
//
//  Created by Hyrum Glen Bateman on 9/21/21.
//

import Foundation

class ScoreBoardController {
    static let sharedInstance = ScoreBoardController()
    var scoreboard = [ScoreBoard]()
    
    func createScoreCard(score: Int, location: String, timestamp: Date) {
        let newScoreCard = ScoreBoard(score: score, location: location, timestamp: timestamp)
        self.scoreboard.append(newScoreCard)
        
        saveToPersistanceStore()
    }
    
    func deleteScoreCard(scoreboards: ScoreBoard) {
        guard let index = scoreboard.firstIndex(of: scoreboards)  else { return }
        self.scoreboard.remove(at: index)
        
        saveToPersistanceStore()
    }
    

//MARK: - Local Persistance
func createPersistanceStore() -> URL {
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let fileURL = url[0].appendingPathComponent("UGolf.json")
    print(fileURL)
    return fileURL
}

func saveToPersistanceStore() {
    do {
        let data = try JSONEncoder().encode(scoreboard)
        try data.write(to: createPersistanceStore())
    } catch {
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    }
}

func loadFromPersistanceStore() {
    do {
        let data = try Data(contentsOf: createPersistanceStore())
        scoreboard = try JSONDecoder().decode([ScoreBoard].self, from: data)
    } catch {
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
    }
}
}

