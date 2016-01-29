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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}