//
//  GameScene+Movement.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

// MARK: Joystick delegate

extension GameScene: ControlInteractionDelegate {
    
    public func didMoveControl(in direction: Direction) {
        if !self.lockMovement {
            self.playerNode.shouldMove = true
            self.playerNode.facingDirection = direction
        
            VoiceOverHandler.shared.speak("Cat started moving \(self.playerNode.facingDirection)")
        }
    }
    
    public func didJump() {
        if !self.lockMovement {
            self.playerNode.jump()
            VoiceOverHandler.shared.speak("Cat jumped")
        }
    }
    
    public func didReleaseControl() {
        if !self.lockMovement {
            self.playerNode.shouldMove = false
            VoiceOverHandler.shared.speak("Cat stopped moving \(self.playerNode.facingDirection)")
        }
    }
    
    override public func update(_ currentTime: TimeInterval) {
        if self.lockMovement {
            return
        }
        
        self.playerNode.update(currentTime)
        
        let cameraMinorLimitNode = self.childNode(withName: "cameraMinorLimit")
        let cameraMajorLimitNode = self.childNode(withName: "cameraMajorLimit")
        
        if (self.playerNode.position.x > cameraMinorLimitNode?.position.x ?? -3550) &&
           (self.playerNode.position.x < cameraMajorLimitNode?.position.x ?? 7850) {
            self.camera?.position = self.playerNode.position
        } else {
            // Only shift camera position along the y axis
            self.camera?.position.y = self.playerNode.position.y
        }
        
        if let forester = self.childNode(withName: "Forester"), self.carrotCollected {
            if forester.position.x - 120 < self.playerNode.position.x &&
                forester.position.x + 120 > self.playerNode.position.x {
                self.carrotCollected = false // Stop any more of these range checks from taking up resources
                self.carrotDelivered = true
                
                VoiceOverHandler.shared.speak("You gave the carrot to Forester. He is happy now!")
                
                if let carrotPopup = self.childNode(withName: "ForesterCarrotPopup") as? SKSpriteNode {
                    carrotPopup.run(SKAction.sequence([
                            SKAction.fadeOut(withDuration: 0.5),
                            SKAction.run {
                                carrotPopup.texture = SKTexture(imageNamed: "ForesterHappyPopup")
                            },
                            SKAction.fadeIn(withDuration: 0.5)
                        ]))
                }
            }
        }
        
        for node in self.voiceOverNodes {
            if node.position.x - 120 < self.playerNode.position.x &&
                node.position.x + 120 > self.playerNode.position.x {
                if self.activatedVoiceOverNodes.contains(node.name ?? "") {
                    continue
                }
                
                self.activatedVoiceOverNodes.append(node.name ?? "")
                
                self.handleVoiceOver(for: node)
            } else {
                if let index = self.activatedVoiceOverNodes.index(of: node.name ?? "") {
                    self.activatedVoiceOverNodes.remove(at: index)
                }
            }
        }
        
        if let cameraScaleLimitNode = self.childNode(withName: "cameraScalePosition") {
            if playerNode.position.x > cameraScaleLimitNode.position.x {
                let timSound = Sound(fileName: "TimWelcomeWWDC.mp3", type: .soundEffect)
                timSound.play(on: self)
                
                self.timerDelegate?.stopTimer()
                
                self.camera?.run(SKAction.scale(to: 2.0, duration: 0.5))
                
                self.lockMovement = true
                self.playerNode.run(SKAction.moveBy(x: 500, y: 0, duration: 3.0))
                self.camera?.run(SKAction.moveBy(x: 500, y: 0, duration: 3.0))
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
                    self.playerNode.run(SKAction.repeatForever(SKAction.sequence([
                            SKAction.run {
                                self.playerNode.jump()
                            },
                            SKAction.wait(forDuration: 1.0)
                        ])))
                    
                    self.gameCompletedCompletionHandler?()
                }
            } else {
                self.camera?.run(SKAction.scale(to: 1.3, duration: 0.5))
            }
        }
    }
    
}

// MARK: Touch controls

extension GameScene {
    
    // Support for touch controls if ever needed
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.allowsTouchControls, let touch = touches.first, let camera = self.camera else {
            return
        }
        
        self.playerNode.facingDirection = self.direction(for: touch, within: camera)
        self.playerNode.shouldMove = true
    }
    
    // Support for touch controls if ever needed
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.allowsTouchControls else {
            return
        }
        
        self.playerNode.shouldMove = false
    }
    
    // Support for touch controls if ever needed
    public func direction(for touch: UITouch, within node: SKNode) -> Direction {
        let location = touch.location(in: node)
        
        if location.x < node.frame.size.width / 2 {
            return .left
        }
        
        if location.x > node.frame.size.width / 2 {
            return .right
        }
        
        return .right // Default to right if something went seriously wrong
    }
    
}
