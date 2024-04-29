//
//  GameSceneContactDelegate.swift
//  FrogJump
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        // kalo player ada kontak sama object lain, maka akan masuk ke case
        // other itu adalah object selain player
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case PhysicsCategory.Block:
            // kalo nabrak block maka kamera akan ninggalin player
            cameraMovePointPerSecond += 150.0
            numScore -= 1
            if numScore <= 0 {
                numScore = 0
                
            }
            scoreLbl.text = "\(numScore)"
            
            run(soundCollision)
            
        case PhysicsCategory.Obstacle:
            reduceLife()
            
            
        case PhysicsCategory.Coin:
            // kalo nambrak koin maka koin akan ilang
            if let node = other.node {
                node.removeFromParent()
                numScore += 1
                // tampilin teks ke layar
                scoreLbl.text = "\(numScore)"
                // setiap kelipatan 5 bakal nambah kecepatan
                if numScore % 5 == 0 {
                    cameraMovePointPerSecond += 100.0
                }
                
                // set highscrore
                
                let highscore = ScoreGenerator.sharedInstance.getHighscore()
                if numScore > highscore {
                    ScoreGenerator.sharedInstance.setHighscore(numScore)
                    ScoreGenerator.sharedInstance.setScore(highscore)
                }
                
                run(soundCoin)
            }
        default: break
        }
    }
}
