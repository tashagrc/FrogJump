//
//  MainMenuExt.swift
//  TribeLeap
//
//  Created by Natasha Radika on 28/04/24.
//

import SpriteKit

// configuration
extension MainMenu {
    func setupBG() {
       let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        addChild(bgNode)
    }
    
    func setupGrounds() {
        for i in 0...2 {
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.name = "ground"
            groundNode.anchorPoint = .zero
            groundNode.zPosition = 1.0
            groundNode.position =  CGPoint(x: CGFloat(i) * groundNode.frame.width, y: 0.0)
            addChild(groundNode)
        }
    }
    
    func moveGrounds() {
        enumerateChildNodes(withName: "ground") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width * 2.0
            }
            
        }
    }
    
    func setupNodes() {
        // tambahkan graphic setting awalnya
        let play = SKSpriteNode(imageNamed: "play")
        play.name = "play"
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + play.size.height/2.0 + 50.0)
        addChild(play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale(0.85)
        highscore.zPosition = 10.0
        highscore.position = CGPoint(x: size.width/2.0, y: play.position.y - play.size.height - 50.0)
        addChild(highscore)
        
    }
    
    func setupPanel() {
        setupContainer()
        
        // panel
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        // highscore
        let x = -panel.frame.width/2.0 + 250.0
        let highscoreLbl = SKLabelNode(fontNamed: "Krungthep")
        highscoreLbl.text = "Highscore: \(CaloriesGenerator.sharedInstance.getHighscore())"
        highscoreLbl.horizontalAlignmentMode = .left
        highscoreLbl.fontSize = 80.0
        highscoreLbl.zPosition = 25.0
        highscoreLbl.position = CGPoint(x: x, y: highscoreLbl.frame.height/2.0 - 30.0)
        panel.addChild(highscoreLbl)
        
        // score
        let scoreLbl = SKLabelNode(fontNamed: "Krungthep")
        scoreLbl.text = "Score: \(CaloriesGenerator.sharedInstance.getScore())"
        scoreLbl.horizontalAlignmentMode = .left
        scoreLbl.fontSize = 80.0
        scoreLbl.zPosition = 25.0
        scoreLbl.position = CGPoint(x: x, y: -scoreLbl.frame.height - 30.0)
        panel.addChild(scoreLbl)
    }
    
    
    func setupContainer() {
        containerNode = SKSpriteNode()
        containerNode.name = "container"
        containerNode.zPosition = 15.0
        containerNode.color = .clear
        containerNode.size = size
        
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
    }
}
