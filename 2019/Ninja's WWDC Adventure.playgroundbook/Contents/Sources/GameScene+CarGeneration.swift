//
//  GameScene+CarGeneration.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/16/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

public extension GameScene {
    
    func stopSpawningCars() {
        self.removeAction(forKey: "carGeneration")
    }
    
    func startSpawningCars() {
        if !self.shouldShowCars {
            return
        }
        
        let styles: [CarNode.Style] = [.red, .yellow, .green, .blue, .purple, .orange]
        let scales: [CarNode.Scale] = [.medium, .small]
        
        let smallPositions = [
            ["smallCarStartPosition", "smallCarEndPosition"]
        ]
        
        let mediumPositions = [
            ["mediumCarStartPosition", "mediumCarEndPosition"],
            ["mediumCarStartPosition2", "mediumCarEndPosition2"],
            ["mediumCarStartPosition3", "mediumCarEndPosition3"],
            ["mediumCarStartPosition4", "mediumCarEndPosition4"]
        ]
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                let car = CarNode()
                car.style = styles.randomElement() ?? .blue
                car.scale = scales.randomElement() ?? .small
 
                let positions: [String]
                
                if car.scale == .small {
                    positions = smallPositions.randomElement() ?? ["smallCarStartPosition", "smallCarEndPosition"]
                } else {
                    positions = mediumPositions.randomElement() ?? ["mediumCarStartPosition", "mediumCarEndPosition"]
                }
                
                car.spawn(in: self, from: positions[0], to: positions[1], duration: self.carDuration)
            },
            SKAction.wait(forDuration: self.carDuration / 2)
            ])), withKey: "carGeneration")
    }
    
}
