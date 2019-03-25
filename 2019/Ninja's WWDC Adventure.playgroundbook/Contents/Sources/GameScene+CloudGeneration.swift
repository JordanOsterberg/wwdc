//
//  GameScene+CloudGeneration.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/17/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func startCloudGeneration() {
        guard let minimumNode = self.childNode(withName: "cloudMinimumNode"), let maximumNode = self.childNode(withName: "cloudMaximumNode") else {
            return
        }
        
        let cloudTextures: [SKTexture] = [
            SKTexture(imageNamed: "cloud1"),
            SKTexture(imageNamed: "cloud2"),
            SKTexture(imageNamed: "cloud3")
        ]
        
        let maxY = Int(maximumNode.position.y)
        let minY = Int(minimumNode.position.y)
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                let selectedYCoordinate = Int.random(in: minY...maxY)
                
                let node = SKSpriteNode(texture: cloudTextures.randomElement() ?? SKTexture(imageNamed: "cloud1"))
                node.position = CGPoint(x: Int(maximumNode.position.x), y: selectedYCoordinate)
                self.addChild(node)
                
                node.run(SKAction.sequence([
                        SKAction.moveTo(x: minimumNode.position.x, duration: 120.0),
                        SKAction.run {
                            node.removeFromParent()
                        }
                    ]))
                
            },
            SKAction.wait(forDuration: 3.0)
            ])))
    }
    
}
