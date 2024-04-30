//
//  ScoreGenerator.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import Foundation

class CaloriesGenerator {
    static let sharedInstance = CaloriesGenerator()
    private init() {
        
    }
    
    static let keyHighscore = "keyHighscore"
    static let keyScore = "keyScore"
    
    func setScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: CaloriesGenerator.keyScore)
    }
    
    func getScore() -> Int {
        return UserDefaults.standard.integer(forKey: CaloriesGenerator.keyScore)
    }
    
    func setHighscore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: CaloriesGenerator.keyHighscore)
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: CaloriesGenerator.keyHighscore)
    }
}
