//
//  GameScene.swift
//  TribeLeap
//
//  Created by Natasha Radika on 25/04/24.
//

import SpriteKit
import GameplayKit

// perbedaan camera node dan camera rect
// camera node adalah view point screen, diletakkan di tengah, maka central view point
// camera rect adalah porsi dari camera node yang bisa dilihat oleh pemain

class GameScene: SKScene {
    
    // properties
    var ground: SKSpriteNode!
    var player: SKSpriteNode!
    
    var obstacles:[SKSpriteNode] = []
    
    var coin: SKSpriteNode!
    
    // view point of game
    var cameraNode = SKCameraNode()
    var cameraMovePointPerSecond: CGFloat = 450.0
    
    // for animation per frame
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    // make player faster the longer you play
    var isTime: CGFloat = 3.0
    
    // make jump
    var onGround = true
    var velocityY: CGFloat = 0.0
    var gravity: CGFloat = 0.6
    var playerPosY: CGFloat = 0.0
    
    // score and life
    //    var numScore: Int = 0
    var howManyMove: Int = 0
    var gameOver = false
    var life: Int = 3
    
    // bikin grafik coin n heart
    var lifeNodes: [SKSpriteNode] = []
    var scoreLbl = SKLabelNode(fontNamed: "Krungthep")
    var coinIcon: SKSpriteNode!
    
    // pause feature
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    
    // sound
    var soundCoin = SKAction.playSoundFileNamed("coin.mp3")
    var soundJump = SKAction.playSoundFileNamed("jump.wav")
    var soundCollision = SKAction.playSoundFileNamed("collision.wav")
    
    // control jump or squat
    var jumpArrow: SKSpriteNode!
    var squatArrow: SKSpriteNode!
    var originalPlayerHeight: CGFloat!
    
    
    // rasio
    
    // bagian layar yg gameplay bisa dimainkan
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) /  2.0
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    // kamera nyorot ke mana aja di layar
    var cameraRect: CGRect {
        let width = playableRect.width
        let height = playableRect.height
        let x = cameraNode.position.x - size.width/2.0 + (size.width - width) / 2.0
        let y = cameraNode.position.y - size.height/2.0 + (size.height - height) / 2.0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    // system
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    // for jumping
    // ketika naik
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // hanya dijalankan kalo ada touch
        guard let touch = touches.first else {
            return
        }
        // tentukan lokasi touch
        let node = atPoint(touch.location(in: self))
        
        // kalo klik menu pause resume dll
        if node.name == "pause" {
            if isPaused {
                return
            }
            createPanel()
            lastUpdateTime = 0.0
            dt = 0.0
            isPaused = true
        }
        else if node.name == "resume" {
            containerNode.removeFromParent()
            isPaused = false
        }
        else if node.name == "quit" {
            let scene = MainMenu(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.8))
        }
        else if node.name == "squatArrow" {
            if !isPaused {
                let squatHeight = originalPlayerHeight * 0.5
                player.size = CGSize(width: player.size.width, height: squatHeight)
                howManyMove += 1
                let highscore = CaloriesGenerator.sharedInstance.getHighscore()
                
                CaloriesGenerator.sharedInstance.setScore(Double(howManyMove) * 0.2)
                
                if (0.2 * Double(howManyMove)) > highscore {
                    CaloriesGenerator.sharedInstance.setHighscore(Double(howManyMove) * 0.2)
                }
            }
        }
        else if node.name == "jumpArrow" {
            // kalo touch ga berhenti, naikin playernya 25pt
            if !isPaused {
                if onGround {
                    onGround = false
                    velocityY = -25.0
                    run(soundJump)
                    howManyMove += 1
                    
                    let highscore = CaloriesGenerator.sharedInstance.getHighscore()
                    
                    CaloriesGenerator.sharedInstance.setScore(Double(howManyMove) * 0.2)
                    
                    if (0.2 * Double(howManyMove)) > highscore {
                        CaloriesGenerator.sharedInstance.setHighscore(Double(howManyMove) * 0.2)
                    }
                }
            }
        }
    }
    
        // memastikan tingginya jump konsisten seberapa lama jump dipencet
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
        }
        
        // update per frame
        override func update(_ currentTime: TimeInterval) {
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
            }
            else {
                dt = 0
            }
            lastUpdateTime = currentTime
            print(dt)
            moveCamera()
            movePlayer()
            
            // ini agar setelah jump balik ke tanah lagi
            velocityY += gravity
            player.position.y -= velocityY
            
            // ini pastikan kalo player ga turun ke bawah ground
            if player.position.y < playerPosY {
                player.position.y = playerPosY
                velocityY = 0.0
                onGround = true
            }
            
            // setelah squat, player akan balik spt semula
            if player.size.height < originalPlayerHeight {
                let newSize = CGSize(width: player.size.width, height: player.size.height + (originalPlayerHeight - player.size.height) * 0.01)
                player.size = newSize
            }
            
            // kalo gameover
            if gameOver {
                let scene = GameOver(size: size)
                scene.scaleMode = scaleMode
                view!.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.8))
            }
            
            
            boundCheckPlayer()
        }
    }
    
    
