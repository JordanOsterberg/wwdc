//
//  GameScene.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import AVFoundation
import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    public var allowsTouchControls = false
    var itemDelegate: ItemCollectionDelegate? = nil
    var timerDelegate: GameTimerDelegate? = nil
    
    var carrotCollected = false
    var carrotDelivered = false
    
    var ticketsCollected: Int = 0 {
        didSet {
            if self.ticketsCollected != 3 {
                return
            }
            
            self.childNode(withName: "GameBarrier")?.removeFromParent()
            
            guard let craigPopup = self.childNode(withName: "CraigTicketPopup") as? SKSpriteNode else {
                return
            }
            
            craigPopup.texture = SKTexture(imageNamed: "CraigHasTicketPopup")
        }
    }
    
    public var showIntroduction = false
    var lockMovement = false

    var playerNode = PlayerNode()
    
    var backgroundMusicNode: SKAudioNode? = nil
    public var backgroundMusicSound = Sound(fileName: "Funky.mp3", type: .backgroundMusic) {
        didSet {
            if let musicNode = self.node(for: self.backgroundMusicSound), self.backgroundMusicAllowed {
                self.backgroundMusicNode?.removeFromParent()
                self.backgroundMusicNode = musicNode
                self.addChild(self.backgroundMusicNode!)
            }
        }
    }
    
    var neonBannerHolder: SKNode? {
        get {
            if let child = self.childNode(withName: "NeonBannerHolder") {
                return child
            }
            
            return nil
        }
    }
    
    var gameCompletedCompletionHandler: (() -> Void)? = nil
    var introductionCompletedHandler: (() -> Void)? = nil
    
    public var backgroundMusicAllowed = true {
        didSet {
            if !self.backgroundMusicAllowed {
                self.backgroundMusicNode?.removeFromParent()
                return
            }
            
            let localSoundCopy = self.backgroundMusicSound
            self.backgroundMusicSound = localSoundCopy
        }
    }
    
    public var allowTicketPickup = true
    
    public var shouldShowCars = true {
        didSet {
            if self.shouldShowCars {
                self.startSpawningCars()
            } else {
                self.stopSpawningCars()
            }
        }
    }
    
    public var shouldShowCarrot = true {
        didSet {
            if self.shouldShowCarrot {
                self.showCarrot()
            } else {
                self.hideCarrot()
            }
        }
    }
    
    public var carDuration: Double = 4.0
    
    public var voiceOverWWDCBannerText: String = "" {
        didSet {
            guard let labelNode = self.childNode(withName: "WWDCBannerTextNode") as? SKLabelNode  else {
                return
            }
            
            if self.voiceOverWWDCBannerText.isEmpty {
                labelNode.alpha = 0
                return
            }
            
            labelNode.alpha = 1
            labelNode.text = self.voiceOverWWDCBannerText
        }
    }
    
    var activatedVoiceOverNodes: [String] = []
    
    override public func sceneDidLoad() {
        self.addChild(self.playerNode)
        
        if let playerStartPosition = self.childNode(withName: "playerStartPosition")?.position {
            self.playerNode.position = playerStartPosition
        }
        
        self.setupPhysics()
        
        if let musicNode = self.node(for: self.backgroundMusicSound), self.backgroundMusicAllowed {
            self.backgroundMusicNode = musicNode
            self.addChild(self.backgroundMusicNode!)
        }
        
        self.neonBannerHolder?.beginFadeAnimation()
        
        self.startSpawningCars()
        self.startCloudGeneration()
        
        let bobAction = SKAction.repeatForever(SKAction.sequence([
                SKAction.moveBy(x: 0, y: 10, duration: 2.0),
                SKAction.moveBy(x: 0, y: -10, duration: 2.0)
            ]))

        for node in self.children.filter({ return $0.name?.lowercased().contains("ticket") == true || $0.name?.lowercased().contains("carrot") == true }) {
            node.run(bobAction)
        }
    }
    
    public override func didMove(to view: SKView) {
        if self.showIntroduction, let camera = self.camera, let minorLimitNode = self.childNode(withName: "cameraMinorLimit"), let majorLimitNode = self.childNode(withName: "cameraMajorLimit"), !UIAccessibility.isVoiceOverRunning {
            self.lockMovement = true
            
            var endingPosition = minorLimitNode.position
            endingPosition.y = self.playerNode.position.y
            endingPosition.x += 50
            
            let startingPosition = majorLimitNode.position
            
            camera.position = startingPosition
            camera.setScale(2.0)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.camera?.run(SKAction.move(to: endingPosition, duration: 20.0))
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 13.0, execute: {
                    self.camera?.run(SKAction.scale(to: 1.3, duration: 6))
                })
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 19.0) {
                    self.lockMovement = false
                    self.timerDelegate?.startTimer()
                    
                    self.introductionCompletedHandler?()
                }
            }
        } else {
            self.timerDelegate?.startTimer()
        }
    }
    
    public func hideTickets() {
        for node in self.children.filter({ return $0.name?.lowercased().contains("ticket|") == true }) {
            node.alpha = 0
        }
    }
    
    public func showTickets() {
        for node in self.children.filter({ return $0.name?.lowercased().contains("ticket|") == true }) {
            node.alpha = 1
        }
    }
    
    public func hideCarrot() {
        self.childNode(withName: "Carrot")?.alpha = 0
        self.childNode(withName: "ForesterCarrotPopup2")?.alpha = 0
    }
    
    public func showCarrot() {
        self.childNode(withName: "Carrot")?.alpha = 1
        self.childNode(withName: "ForesterCarrotPopup2")?.alpha = 1
    }
    
}
