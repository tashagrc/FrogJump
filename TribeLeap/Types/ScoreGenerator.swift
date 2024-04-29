//
//  ScoreGenerator.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import Foundation

class ScoreGenerator {
    static let sharedInstance = ScoreGenerator()
    private init() {
        
    }
    
    static let keyHighscore = "keyHighscore"
    static let keyScore = "keyScore"
    
    func setScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: ScoreGenerator.keyScore)
    }
    
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: ScoreGenerator.keyScore)
    }
    
    func setHighscore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: ScoreGenerator.keyHighscore)
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: ScoreGenerator.keyHighscore)
    }
}
