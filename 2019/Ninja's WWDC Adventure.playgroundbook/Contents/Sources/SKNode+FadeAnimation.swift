//
//  SKGeneratedAnimationSequenceNode.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/15/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

public extension SKNode {
    
    var generatedFadeAnimation: SKAction {
        var subActions: [SKAction] = []
        var resetActions: [SKAction] = []
        
        resetActions.append(SKAction.wait(forDuration: 1.0))
        
        for child in self.children {
            if child.name?.contains("ignore") == true {
                continue // Ignore anything with the ignore keyword
            }
            
            if child.name?.contains("delay") == true {
                subActions.append(SKAction.wait(forDuration: 0.5))
                continue
            }
            
            subActions.append(SKAction.run {
                child.alpha = 0
            })
            
            subActions.append(SKAction.wait(forDuration: 0.4))
            
            resetActions.append(SKAction.run {
                if child.name?.contains("fullOpacity") == true {
                    child.alpha = 1
                } else {
                    child.alpha = 0.6
                }
            })
        }
        
        resetActions.append(SKAction.wait(forDuration: 1.0))

        return SKAction.repeatForever(SKAction.sequence(subActions + resetActions))
    }
    
    func beginFadeAnimation() {
        self.run(self.generatedFadeAnimation, withKey: "generatedAnimation")
    }
    
    func endFadeAnimation() {
        self.removeAction(forKey: "generatedAnimation")
    }
    
}
