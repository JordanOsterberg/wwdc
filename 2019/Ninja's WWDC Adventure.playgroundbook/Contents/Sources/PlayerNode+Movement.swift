//
//  PlayerNode+Movement.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

extension PlayerNode {
    
    /// Applies an impulse that makes the player jump
    public func jump() {
        if self.isAirborne {
            return
        }
        
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        self.isAirborne = true
    }
    
    /// Move the player in a given Direction
    /// See Direction
    public func move(in direction: Direction) {
        if !self.canMove {
            return
        }
        
        var trueMovementSpeed: Double
        
        if direction == .right {
            trueMovementSpeed = 10
        } else {
            trueMovementSpeed = -10
        }
        
        trueMovementSpeed *= self.movementSpeed
        
        // Move the player
        self.run(SKAction.move(
            by: CGVector(dx: trueMovementSpeed, dy: 0),
            duration: 0.2))
    }
    
}
