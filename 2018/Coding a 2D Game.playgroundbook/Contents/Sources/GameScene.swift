//
//  GameScene.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/15/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

public class GameScene: SKScene {
    
    var parentViewController : GameViewController? = nil
    var catNode : PlayerNode? = nil
    var catnipNode : SKSpriteNode? = nil
    var checkpointNode : SKSpriteNode? = nil
    
    var fishCount : Int = 0 {
        didSet {
            self.parentViewController?.updateFishCount(fishCount: fishCount)
        }
    }
    
    var shouldUseUIControls = false
    var playerMovementDisabled = false
    var forceCheckpoint = false
    
    var reachedCheckpoint = false {
        didSet {
            if reachedCheckpoint {
                self.checkpointNode?.texture = SKTexture(imageNamed: "checkpointActive")
            } else {
                self.checkpointNode?.texture = SKTexture(imageNamed: "checkpointInactive")
            }
        }
    }
    
    var canCheckpointActivate = true
    var canCatnipEndGame = true
    var startAtCatnip = false
    
    var rules = [PlaygroundbookSceneRules]() {
        didSet {
            AudioHandler.shared.rules = self.rules
        }
    }
    
    var gameLoseMessages = ["Lava = Dead Cat! 😭", "Lava isn't good, you know.", "Steer clear of the lava.", "This really isn't your day.", "Toasty. Lava isn't good for cats."]
    var gameWinMessages = ["You win!", "Bathe in the sweet catnip!", "Winner Winner Chicken Dinner", "🏆 This is for you.", "Sweet, sweet catnip."]
    
    /*
     "Balloon Game" Kevin MacLeod (incompetech.com)
     Licensed under Creative Commons: By Attribution 3.0 License
     http://creativecommons.org/licenses/by/3.0/
    */
    
    var backgroundAudioNode : SKAudioNode? = nil
    
    let backgroundMusicSound = Sound(type: .background, fileUrl: Bundle.main.url(forResource: "balloonGame", withExtension: "mp3"))
    
    let dingSound = Sound(type: .effect, fileName: "ding.mp3")
    let groanSound = Sound(type: .effect, fileName: "catGroan.wav")
    let meowSound = Sound(type: .effect, fileName: "catMeow.wav")
    
    deinit {
        print ("GameScene: deinit")
    }
    
    override public func didMove(to view: SKView) {
        startGame()
    }
    
    public func startGame() {
        if !rules.contains(.noPlayer), let camera = self.scene?.camera {
            self.catNode = createPlayer()
            self.catNode?.position = camera.position
            self.catNode?.type = .orangeTabby
            
            self.addChild(self.catNode!)
        }
        
        self.catnipNode = self.scene?.childNode(withName: "catnip") as? SKSpriteNode
        self.checkpointNode = self.scene?.childNode(withName: "checkpoint") as? SKSpriteNode
        
        self.physicsWorld.contactDelegate = self
        
        if let backgroundMusicNode = AudioHandler.shared.action(for: backgroundMusicSound) {
            self.backgroundAudioNode = backgroundMusicNode
            self.addChild(self.backgroundAudioNode!)
        }
        
        if rules.contains(.noFish) {
            self.scene?.childNode(withName: "FishHolder")?.removeFromParent()
        }
        
        if rules.contains(.noCatnip) {
            self.catnipNode?.removeFromParent()
        }
        
        if rules.contains(.noCheckpoint) {
            self.checkpointNode?.removeFromParent()
        }
        
        if let cloudHolder = self.scene?.childNode(withName: "CloudHolder") {
            let options = [SKTexture(imageNamed: "cloud1"), SKTexture(imageNamed: "cloud2"), SKTexture(imageNamed: "cloud3")]
            
            for child in cloudHolder.children {
                if let spriteNode = child as? SKSpriteNode {
                    spriteNode.texture = options.random
                }
            }
            
            cloudHolder.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.moveBy(x: 0, y: 20, duration: 5.0),
                SKAction.moveBy(x: 0, y: -20, duration: 5.0)
                ])))
        }
        
        if let fishHolder = self.scene?.childNode(withName: "FishHolder") {
            fishHolder.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.moveBy(x: 0, y: 10, duration: 2.0),
                SKAction.moveBy(x: 0, y: -10, duration: 2.0)
                ])))
        }
        
        setupPhysics()
    }
    
    func createPlayer() -> PlayerNode {
        let node = PlayerNode(texture: SKTexture(imageNamed: "orangeTabby"))
        node.setScale(0.3)
        node.name = "cat"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = playerCategory
        node.physicsBody?.contactTestBitMask = floorCategory | lavaCategory | catnipCategory | fishCategory | checkpointCategory
        return node
    }
    
    let noneCategory : UInt32 = 0
    let playerCategory : UInt32 = 1
    let floorCategory : UInt32 = 2
    let lavaCategory : UInt32 = 3
    let catnipCategory : UInt32 = 4
    let fishCategory : UInt32 = 5
    let checkpointCategory : UInt32 = 6
    
    func setupPhysics() {
        self.checkpointNode?.physicsBody?.categoryBitMask = noneCategory
        self.checkpointNode?.physicsBody?.collisionBitMask = noneCategory
        self.checkpointNode?.physicsBody?.contactTestBitMask = playerCategory

        for node in self.children {
            if node.name == nil {
                continue
            }

            if node.name!.lowercased().contains("platform") || node.name!.lowercased().contains("floor") {
                node.physicsBody?.categoryBitMask = floorCategory
            } else if node.name!.lowercased().contains("lava") {
                node.physicsBody?.categoryBitMask = lavaCategory
            } else if node.name!.lowercased().contains("fish") {
                node.physicsBody?.categoryBitMask = noneCategory
                node.physicsBody?.collisionBitMask = noneCategory
                node.physicsBody?.contactTestBitMask = playerCategory
            }
        }
    }
    
    var isScreenBeingTouched = false
    var touchDirection : PlayerLookingDirection = .right
    
    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if forceCheckpoint {
            self.reachedCheckpoint = true
        }
        
        if self.playerMovementDisabled {
            return
        }
        
        if catNode != nil { // Update the camera position to be at the cat's location
            self.camera?.position = self.catNode!.position
        }
        
        if !self.isScreenBeingTouched || rules.contains(.noMovement) {
            return
        }
        
        catNode?.move(in: self.touchDirection)
    }
    
    func handleMovementFromVoiceOver(direction: PlayerLookingDirection) {
        if !rules.contains(.noJumping) {
            catNode?.jump()
            
            VoiceOverHandler.shared.speak("Cat moved \(direction.rawValue) and jumped")
        } else {
            if rules.contains(.noMovement) {
                VoiceOverHandler.shared.speak("Cat can't move")
                return
            }
            
            VoiceOverHandler.shared.speak("Cat moved \(direction.rawValue)")
        }
        
        self.touchDirection = direction
        self.isScreenBeingTouched = true
    }
    
    func resetFromCheckpoint() {
        if self.checkpointNode != nil {
            self.catNode?.position = self.checkpointNode!.position
        }
        
        self.reachedCheckpoint = true
    }
    
    func resetFromCatnip(canCatnipEndGame: Bool = false) {
        if self.catnipNode != nil {
            self.startAtCatnip = true
            self.canCatnipEndGame = canCatnipEndGame
            
            self.catNode?.position = self.catnipNode!.position
            self.catNode?.position.x += 100
        }
    }
    
    func handleDeath() {
        self.playerMovementDisabled = true
        
        self.backgroundAudioNode?.removeFromParent()
        AudioHandler.shared.action(for: self.groanSound, on: self.scene)
        
        self.showLabel(type: .fail, for: 2.5, completionHandler: {
            self.parentViewController?.resetScene(atCheckpoint: self.reachedCheckpoint)
        })
    }
    
    func handleGameWin() {
        self.playerMovementDisabled = true
        
        self.catNode?.isGameOver = true
        self.catNode?.jump()
        
        self.backgroundAudioNode?.removeFromParent()
        AudioHandler.shared.action(for: self.meowSound, on: self.scene)
        
        self.showLabel(type: .success, for: 2.5, completionHandler: {
            self.parentViewController?.resetScene(atCheckpoint: false, atCatnip: self.startAtCatnip)
        })
    }
    
    func showLabel(with text: String = "", type: GameEndMessageType = .none, for timeInterval: TimeInterval, completionHandler: @escaping () -> Void) {
        var string = ""
        
        if type == .none {
            string = text
        } else if type == .success {
            string = self.gameWinMessages.random
        } else if type == .fail {
            string = self.gameLoseMessages.random
        }
        
        VoiceOverHandler.shared.speak("Text on screen: \(string)")
        
        let label = SKLabelNode(text: string)
        label.fontSize = 50
        label.fontName = UIFont.systemFont(ofSize: 50, weight: .light).fontName
        label.zPosition = 10000
        label.color = UIColor.white
        
        if self.catNode != nil {
            label.position = self.catNode!.position
            label.position.y += 100
        } else {
            label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        }
        
        self.scene?.addChild(label)
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { _ in
            label.removeFromParent()
            completionHandler()
        })
    }

}

extension GameScene : SKPhysicsContactDelegate {
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if self.playerMovementDisabled {
            return
        }
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if nodeA == self.catNode || nodeB == self.catNode { // One of them must be the cat node
                let otherNode = nodeA == self.catNode ? nodeB : nodeA
                
                if nodeNameContains(strings: ["platform", "floor"], node: otherNode) {
                    VoiceOverHandler.shared.speak("Cat landed on platform")
                    self.catNode?.didLand()
                } else if nodeNameContains(string: "lava", node: otherNode) {
                    VoiceOverHandler.shared.speak("Cat landed on lava")
                    self.handleDeath()
                } else if nodeNameContains(string: "catnip", node: otherNode) {
                    VoiceOverHandler.shared.speak("Cat touched catnip")
                    if self.canCatnipEndGame {
                        self.handleGameWin()
                    }
                } else if nodeNameContains(string: "fish", node: otherNode) {
                    otherNode.removeFromParent()
                    
                    AudioHandler.shared.action(for: dingSound, on: self.scene)
                    self.fishCount += 1
                    
                    VoiceOverHandler.shared.speak("Cat collected fish. You have \(self.fishCount) fish")
                } else if nodeNameContains(string: "checkpoint", node: otherNode) {
                    VoiceOverHandler.shared.speak("Cat touched checkpoint")
                    
                    if self.canCheckpointActivate {
                        self.reachedCheckpoint = true
                        
                        AudioHandler.shared.action(for: dingSound, on: self.scene)
                    }
                }
            }
        }
    }
    
    func nodeNameContains(string: String = "", strings: [String] = [], node: SKNode) -> Bool {
        if strings.count != 0 {
            for str in strings {
                if nodeNameContains(string: str, node: node) {
                    return true
                }
            }
        }
        
        if node.name == nil {
            return false
        }
        
        return node.name!.lowercased().contains(string)
    }
    
}

extension GameScene : OnscreenControlsDelegate {
    
    public func leftTapped() {
        self.isScreenBeingTouched = true
        self.touchDirection = .left
    }
    
    public func leftReleased() {
        VoiceOverHandler.shared.speak("Cat stopped moving")
        self.isScreenBeingTouched = false
    }
    
    public func rightTapped() {
        self.isScreenBeingTouched = true
        self.touchDirection = .right
    }
    
    public func rightReleased() {
        VoiceOverHandler.shared.speak("Cat stopped moving")
        self.isScreenBeingTouched = false
    }
    
    public func jumpTapped() {
        if !rules.contains(.noJumping) {
            self.catNode?.jump()
        }
    }
    
    // VoiceOver Helpers
    public func leftTappedVoiceOver() {
        self.handleMovementFromVoiceOver(direction: .left)
    }
    
    public func rightTappedVoiceOver() {
        self.handleMovementFromVoiceOver(direction: .right)
    }
    
}

enum GameEndMessageType {
    
    case success
    case fail
    case none
    
}




