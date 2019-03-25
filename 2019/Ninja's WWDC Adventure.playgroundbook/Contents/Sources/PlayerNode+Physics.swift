//
//  PlayerNode+Physics.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

public extension PlayerNode {
    
    /// Responds to physics
    public func didBegin(_ contact: SKPhysicsContact, with oppositeBody: SKPhysicsBody, completion: ((_ continueHandling: Bool) -> Void)) {
        guard let oppositeNode = oppositeBody.node else {
            completion(false)
            return
        }
        
        let side = self.sideForCollision(with: oppositeNode)
        
        if side == .bottom {
            self.isAirborne = false // Reset the airborne property
        }
        
        if oppositeNode.name?.lowercased().contains("slope") == true {
            self.physicsBody?.allowsRotation = true
            self.physicsBody?.friction = 4
        } else {
            self.physicsBody?.allowsRotation = false
            self.zRotation = 0
            self.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.angularVelocity = 0
            self.physicsBody?.friction = 0.20000000298023224
        }
        
        completion(false)
    }
    
}
