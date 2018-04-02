//
//  Player.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/15/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import SpriteKit

public class PlayerNode : SKSpriteNode {
    
    public var type : PlayerType = .whiteFluffy {
        didSet {
            let texture : SKTexture
            
            if type == .orangeTabby {
                texture = SKTexture(imageNamed: "orangeTabby")
            } else {
                texture = SKTexture(imageNamed: "whiteCat")
            }
            
            self.texture = texture
        }
    }
    
    private var lookingDirection : PlayerLookingDirection = .right
    private var isAirborne = false
    public var isGameOver = false

    public func move(in direction: PlayerLookingDirection) {
        let vector = CGVector(dx: direction == .left ? -10 : 10, dy: 0)
        self.run(SKAction.move(by: vector, duration: 0.2))
        
        if self.lookingDirection != direction {
            self.xScale *= -1
        }
        
        self.lookingDirection = direction
    }
    
    public func jump() {
        if self.isAirborne {
            if !self.isGameOver {
                return
            }
        }
        
        let vector = CGVector(dx: 0, dy: 600)
        self.physicsBody?.applyImpulse(vector)
        
        self.isAirborne = true
    }
    
    public func didLand() {
        self.isAirborne = false
    }
    
}

public enum PlayerLookingDirection : String {
    
    case left
    case right
    
}

public enum PlayerType : String {
    
    case orangeTabby
    case whiteFluffy
    
}
