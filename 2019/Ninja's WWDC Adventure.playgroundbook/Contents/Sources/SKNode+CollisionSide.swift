//
//  SKNode+CollisionSide.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func calculatePhysicsCross() -> (down: CGPoint, up: CGPoint, left: CGPoint, right: CGPoint) {
        let halfWidth = self.frame.width / 2
        let halfHeight = self.frame.height / 2
        
        let down = CGPoint(x: self.frame.origin.x + halfWidth, y: self.frame.origin.y)
        let up = CGPoint(x: self.frame.origin.x + halfWidth, y: self.frame.origin.y + self.frame.size.height)
        let left = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + halfHeight)
        let right = CGPoint(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y + halfHeight)
        
        return (down, up, left, right)
    }
    
    func sideForCollision(with node: SKNode) -> CollisionSide {
        let physicsCross = self.calculatePhysicsCross()
        let otherPhysicsCross = node.calculatePhysicsCross()
        
        let downDistance = getDistance(physicsCross.down, otherPhysicsCross.down)
        let upDistance = getDistance(physicsCross.up, otherPhysicsCross.up)
        let leftDistance = getDistance(physicsCross.left, otherPhysicsCross.left)
        let rightDistance = getDistance(physicsCross.right, otherPhysicsCross.right)
        
        let asArray = [downDistance, upDistance, leftDistance, rightDistance]
        
        if asArray[0] == downDistance {
            return .bottom
        } else if asArray[0] == upDistance {
            return .top
        } else if asArray[0] == leftDistance {
            return .left
        } else if asArray[0] == rightDistance {
            return .right
        }
    
        return .bottom
    }
    
    fileprivate func getDistance(_ pointOne: CGPoint, _ pointTwo: CGPoint) -> CGFloat {
        let xDist = (pointTwo.x - pointOne.x)
        let yDist = (pointTwo.y - pointOne.y)
        
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    enum CollisionSide {
        case top
        case left
        case right
        case bottom
    }
    
}
