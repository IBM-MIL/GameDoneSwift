//
//  GameScene.swift
//  GameDoneSwift
//
//  Created by Kyle Craig on 1/29/16.
//  Copyright (c) 2016 IBM MIL. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let kingSpriteName = "king"
    let groundSpriteName = "ground"
    let backgroundSpriteName = "background"
    
    var king: SKSpriteNode!
    var ground: SKSpriteNode!
    var background: SKSpriteNode!
    
    var onGround = true
    
    var backgrounds: [SKSpriteNode] = []
    
    let backgroundTime: CFTimeInterval = 1.0
    var previousTime: CFTimeInterval = 0
    var backgroundTimeCount: CFTimeInterval = 0
    
    var platforms: [SKShapeNode] = []
    
    // Platform Configuration
    let platformStartX: CGFloat = 2900.0
    let platformHeight: CGFloat = 100.0
    let minPlatformWidth: UInt32 = 100
    let platformMaxWidthChange: UInt32 = 700
    let minPlatformY: UInt32 = 200
    let platformMaxYChange: UInt32 = 200
    let platformSpacing: CGFloat = 450.0
    
    let platformTime: CFTimeInterval = 0.5
    var platformTimeCount: CFTimeInterval = 0
    
    var player: AVAudioPlayer!
    
    var sceneController: GameViewController!
    var score = 0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        guard let king = self.childNode(withName: kingSpriteName) as? SKSpriteNode,
            let ground = self.childNode(withName: groundSpriteName) as? SKSpriteNode,
            let background = self.childNode(withName: backgroundSpriteName) as? SKSpriteNode
            else {
                print("Sprites not found.")
                return
        }
        
        self.king = king
        self.ground = ground
        self.background = background
        
        setPhysicsBitMasks()
        self.physicsWorld.contactDelegate = self
        
        backgrounds.append(self.background)
        addNextBG()
        
        do {
            let sickBeats = URL(fileURLWithPath: Bundle.main.path(forResource: "sickBeats", ofType: "mp3")!)
            player = try AVAudioPlayer(contentsOf: sickBeats)
            player.numberOfLoops = -1
            player.play()
        } catch {
            print("Failed to load audio.")
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        jump()
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        platformTimeCount += currentTime - previousTime
        
        if platformTimeCount > platformTime {
            self.addPlatform()
            platformTimeCount = 0
        }
        backgroundTimeCount += currentTime - previousTime
        
        if backgroundTimeCount > backgroundTime {
            self.addNextBG()
            backgroundTimeCount = 0
        }
        
        previousTime = currentTime
        
        
    }
    
    override func didFinishUpdate() {
        /* Called after each update */
        
        movePlayer()
        if king.position.y < -200 {
            gameOver()
        }
        score += 1
    }
    
    func gameOver() {
        self.isPaused = true
        presentScore()
    }
    
    func presentScore() {
        let alert = UIAlertController(title: "Game Over!", message:"Your final score was \(score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { _ in
            self.reset()
            })
        sceneController.present(alert, animated: true){}
        
    }
    
    func reset() {
        self.removeAllChildren()
        self.addChild(background)
        self.addChild(ground)
        self.addChild(king)
        
        self.king.position = CGPoint(x: 200, y: 220)
        moveCameraWith(king, offset: 350)
        
        platforms = []
        backgrounds = []
        backgrounds.append(background)
        addNextBG()
        
        score = 0
        
        self.isPaused = false
    }
    
    func setPhysicsBitMasks() {
        /* Sets up the SKSpriteNode bit masks so they can interact in the physics engine */
        
        self.king.physicsBody?.categoryBitMask = PhysicsBitMasks.player
        self.king.physicsBody?.collisionBitMask = PhysicsBitMasks.ground
        self.king.physicsBody?.contactTestBitMask = PhysicsBitMasks.ground
        
        self.ground.physicsBody?.categoryBitMask = PhysicsBitMasks.ground
        self.ground.physicsBody?.collisionBitMask = PhysicsBitMasks.player
        self.ground.physicsBody?.contactTestBitMask = PhysicsBitMasks.player
        
    }
    
    func jump() {
        /* Applies a y velocity to the player character */
        
        if onGround {
            self.king.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 1000.0))
            onGround = false
        }
        
    }
    
    func movePlayer() {
        /* Sets the x velocity of the player character */
        
        self.king.physicsBody?.velocity.dx = 1000.0
         moveCameraWith(self.king, offset: 350)
        
    }
    
    func moveCameraWith(_ node: SKNode, offset: CGFloat) {
        /* Moves the camera along the x-axis with a specified node and offset */
        
        guard let camera = self.camera else {
            print("No camera.")
            return
        }
        
        camera.position = CGPoint(x: node.position.x + offset, y: 375)
        
    }
    
    func addNextBG() {
        /* Adds a new background sprite to backgrounds. */
        
        let nextBG = SKSpriteNode(imageNamed: "background")
        nextBG.size = CGSize(width: 1920.0, height: 1080.0)
        nextBG.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        nextBG.position.x = backgrounds.last!.position.x + backgrounds.last!.frame.width
        
        backgrounds.append(nextBG)
        addChild(nextBG)
        if backgrounds.count > 100 {
            backgrounds.first?.removeFromParent()
            backgrounds.removeFirst()
        }
        
    }
    
    func platformWithRect(_ rect: CGRect) -> SKShapeNode {
        /* Create a new platform node and its physics body. */
        
        let platform = SKShapeNode(rect: rect)
        platform.name = "platform"
        platform.fillColor = UIColor(red: 206/256, green: 229/256, blue: 139/256, alpha: 1.0)
        platform.zPosition = 1
        
        let center = CGPoint(x: platform.frame.origin.x + platform.frame.width/2, y: platform.frame.origin.y + platform.frame.height/2)
        platform.physicsBody = SKPhysicsBody(rectangleOf: rect.size, center: center)
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.pinned = true
        platform.physicsBody?.categoryBitMask = PhysicsBitMasks.ground
        platform.physicsBody?.collisionBitMask = PhysicsBitMasks.player
        platform.physicsBody?.contactTestBitMask = PhysicsBitMasks.player
        
        return platform
        
    }
    
    func addPlatform() {
        /* Add a new platform to the game. */
        
        var x: CGFloat = platformStartX
        let y = CGFloat(arc4random_uniform(platformMaxYChange)+minPlatformY)
        let width = CGFloat(arc4random_uniform(platformMaxWidthChange)+minPlatformWidth)
        
        if platforms.count > 0 {
            let previous = platforms.last!
            x = previous.frame.origin.x + previous.frame.width + platformSpacing
        }
        
        let rect = CGRect(x: x, y: y, width: width, height: platformHeight)
        
        let platform = platformWithRect(rect)
        
        platforms.append(platform)
        addChild(platform)
        if platforms.count > 150 {
            platforms.first?.removeFromParent()
            platforms.removeFirst()
        }
        
    }

}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Fires when contact is made between two physics bodies with collision bit masks */
        onGround = true

    }
    
}
