//
//  PlayerNode.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

/// PlayerNode represents the main character of the game
public class PlayerNode: SKSpriteNode {
    
    init() {
        let playerTexture = SKTexture(imageNamed: "playerTexture")
        
        super.init(texture: playerTexture,
                   color: UIColor.clear,
                   size: CGSize(width: 232, height: 116.5))
        
        self.physicsBody = SKPhysicsBody(texture: playerTexture, size: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        
        self.zPosition = 666.66 // Apple 1!!!
        
        self.name = "player"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The direction the player is currently facing
    public var facingDirection: Direction = .right {
        didSet {
            if oldValue != facingDirection {
                self.xScale *= -1
            }
        }
    }
    
    /// If true, the player cannot jump a second time
    public var isAirborne = false
    
    /// If true, the player is allowed to jump
    public var canJump = true
    
    /// Determines if the player should move when the update function is called
    public var shouldMove = false
    
    /// canMove determines if the cat is allowed to move either left or right
    /// If false, movement is locked
    public var canMove: Bool {
        return self.canMoveLeft || self.canMoveRight
    }
    
    /// Can the player move left
    public var canMoveLeft = true
    
    /// Can the player move right
    public var canMoveRight = true
    
    /// This value is the multiplier for speed
    /// The higher the value, the faster the player will move, and vice versa
    public var movementSpeed = 0.8
    
    /// Called by the SKScene to update the player
    public func update(_ currentTime: TimeInterval) {
        if self.shouldMove {
            self.move(in: self.facingDirection)
        }
    }
    
}
