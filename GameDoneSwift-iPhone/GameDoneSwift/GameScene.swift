//
//  GameScene.swift
//  GameDoneSwift
//
//  Created by Kyle Craig on 1/29/16.
//  Copyright (c) 2016 IBM MIL. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let kingSpriteName = "king"
    let groundSpriteName = "ground"
    let backgroundSpriteName = "background"
    
    var king: SKSpriteNode!
    var ground: SKSpriteNode!
    var background: SKSpriteNode!
    
    var onGround = true
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        guard let king = self.childNodeWithName(kingSpriteName) as? SKSpriteNode,
            let ground = self.childNodeWithName(groundSpriteName) as? SKSpriteNode,
            let background = self.childNodeWithName(backgroundSpriteName) as? SKSpriteNode
            else {
                print("Sprites not found.")
                return
        }
        
        self.king = king
        self.ground = ground
        self.background = background
        
        setPhysicsBitMasks()
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        jump()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func didFinishUpdate() {
        /* Called after each update */
        
        movePlayer()
        
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
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Fires when contact is made between two physics bodies with collision bit masks */
        onGround = true

    }
    
}