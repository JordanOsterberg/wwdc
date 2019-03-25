//
//  GameScene+Physics.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    var noneCategory: UInt32 {
        return 0
    }
    
    var playerCategory: UInt32 {
        return 1
    }
    
    var floorCategory: UInt32 {
        return 2
    }
    
    var slopedFloorCategory: UInt32 {
        return 3
    }
    
    var ticketCategory: UInt32 {
        return 4
    }
    
    var carrotCategory: UInt32 {
        return 5
    }
    
    func setupPhysics() {
        self.physicsWorld.contactDelegate = self
        
        self.playerNode.physicsBody?.categoryBitMask = self.playerCategory
        self.playerNode.physicsBody?.contactTestBitMask = self.floorCategory | self.slopedFloorCategory | self.ticketCategory
        self.playerNode.physicsBody?.collisionBitMask = self.floorCategory | self.slopedFloorCategory
        
        for node in self.children {
            guard let name = node.name?.lowercased() else {
                continue
            }
            
            if name.contains("floor") {
                node.physicsBody?.categoryBitMask = self.floorCategory
            } else if name.contains("slope") {
                node.physicsBody?.categoryBitMask = self.slopedFloorCategory
            } else if name.contains("ticket") {
                node.physicsBody?.categoryBitMask = self.ticketCategory
            } else if name.contains("carrot") {
                node.physicsBody?.categoryBitMask = self.carrotCategory
            }
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        // Ensure that the player is the one interacting with an object
        guard contact.bodyA.node == self.playerNode || contact.bodyB.node == self.playerNode else {
            return
        }
        
        let oppositeBody = contact.bodyA.node == self.playerNode ? contact.bodyB : contact.bodyA
        
        guard oppositeBody.node != nil else {
            return
        }
        
        self.playerNode.didBegin(contact, with: oppositeBody, completion: { continueHandling in
            guard !continueHandling else {
                return
            }
            
            // Not handled by player node for some reason
            if oppositeBody.categoryBitMask == self.ticketCategory && oppositeBody.node?.parent == self && self.allowTicketPickup { // Ensure that this is a ticket and its parent is the scene
                oppositeBody.node?.removeFromParent()
                
                // Check Number
                let number = Int(oppositeBody.node?.name?.split(separator: "|")[1] ?? "1") ?? 1
                var item: Item
                
                switch (number) {
                case 1:
                    item = .ticketOne
                    break
                case 2:
                    item = .ticketTwo
                    break
                case 3:
                    item = .ticketThree
                    break
                default:
                    item = .ticketOne
                    break
                }
                
                self.itemDelegate?.didCollect(item: item, on: self)
                
                self.ticketsCollected += 1
                
                VoiceOverHandler.shared.speak("Ninja collected ticket piece. You have \(self.ticketsCollected) of 3 ticket pieces.")
                
                return
            }
            
            if oppositeBody.categoryBitMask == self.carrotCategory && oppositeBody.node?.parent == self && self.shouldShowCarrot {
                oppositeBody.node?.removeFromParent()
                
                self.carrotCollected = true
                
                VoiceOverHandler.shared.speak("Ninja collected carrot. Go back left and give the carrot to Forester the dog.")
                
                if let carrotPopup2 = self.childNode(withName: "ForesterCarrotPopup2") {
                    carrotPopup2.run(SKAction.fadeOut(withDuration: 1.0))
                }
                
                self.itemDelegate?.didCollect(item: .carrot, on: self)
                
                return
            }
        })
    }
    
}
