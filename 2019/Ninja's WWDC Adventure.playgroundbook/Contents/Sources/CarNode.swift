//
//  CarNode.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/15/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

class CarNode: SKSpriteNode {
    
    var style: Style = .red {
        didSet {
            self.texture = SKTexture(imageNamed: self.style.rawValue)
        }
    }
    
    var scale: Scale = .medium {
        didSet {
            if self.scale == .medium {
                self.zPosition = -2
                self.setScale(1.0)
                self.xScale = 1
            } else if self.scale == .small {
                self.zPosition = -8
                self.setScale(0.5)
                self.xScale = -0.5
            }
        }
    }
    
    init() {
        let playerTexture = SKTexture(imageNamed: "Red Car")
        
        super.init(texture: playerTexture,
                   color: UIColor.clear,
                   size: CGSize(width: 143, height: 102))
        
        self.name = "car"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Style: String {
        
        case red = "Red Car"
        case orange = "Orange Car"
        case purple = "Purple Car"
        case yellow = "Yellow Car"
        case green = "Green Car"
        case blue = "Blue Car"
        
    }
    
    enum Scale {
        
        case medium, small
        
    }
    
    func spawn(in scene: SKScene, from startPositionName: String, to endPositionName: String, duration: Double) {
        guard let startNode = scene.childNode(withName: startPositionName), let endNode = scene.childNode(withName: endPositionName) else {
            print ("Failed to spawn car node with SP and EP: \(startPositionName) \(endPositionName)")
            return
        }
        
        scene.addChild(self)
        
        self.position = startNode.position
        
        self.run(SKAction.sequence([
                SKAction.move(to: endNode.position, duration: duration),
                SKAction.wait(forDuration: duration),
                SKAction.run {
                    self.removeFromParent()
                }
            ]))
    }
    
}
