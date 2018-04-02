//
//  GameViewController.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/15/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import PlaygroundSupport

public class GameViewController: UIViewController {
    
    let fishCounterLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.text = "0 fish"
        return label
    }()
    
    let arButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arkit-icon"), for: .normal)
        return button
    }()
    
    let rightButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Right"), for: .normal)
        return button
    }()
    
    let leftButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Left"), for: .normal)
        return button
    }()
    
    let rightJumpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Jump"), for: .normal)
        return button
    }()
    
    let leftJumpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Jump"), for: .normal)
        return button
    }()
    
    public var showARButton = false
    public var canOpenAR = true
    
    public var currentScene : GameScene? = nil
    public var rules = [PlaygroundbookSceneRules]() {
        didSet {
            self.currentScene?.rules = rules
        }
    }
    
    public var controlsDelegate : OnscreenControlsDelegate? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
 
        // Let's setup the SKView
        self.view = SKView(frame: UIScreen.main.bounds)
        
        if let view = self.view as! SKView? {
            startScene(on: view)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
        
        // If .noFish is a rule, don't add the label
        if !rules.contains(.noFish) {
            self.setupLabels()
        }
        
        // Show the AR button if enabled
        if showARButton {
            self.setupARButton()
        }
        
        // Let's setup the UI controls
        self.setupUIControls()
        
        // Listen for VoiceOver status changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleVoiceOver), name: NSNotification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
    }
    
    // MARK: UI Building methods
    
    func setupUIControls() {
        self.view.addSubview(self.rightButton)
        
        self.rightButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.rightButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        self.rightButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.rightButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchDown)
        self.rightButton.addTarget(self, action: #selector(rightButtonReleased), for: .touchUpInside)
        
        self.view.addSubview(self.leftButton)
        
        self.leftButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.leftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        self.leftButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.leftButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchDown)
        self.leftButton.addTarget(self, action: #selector(leftButtonReleased), for: .touchUpInside)
        
        self.view.addSubview(self.rightJumpButton)
        
        self.rightJumpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.rightJumpButton.bottomAnchor.constraint(equalTo: self.rightButton.topAnchor, constant: -10).isActive = true
        self.rightJumpButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.rightJumpButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.rightJumpButton.addTarget(self, action: #selector(jumpButtonTapped), for: .touchDown)
        
        self.view.addSubview(self.leftJumpButton)
        
        self.leftJumpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.leftJumpButton.bottomAnchor.constraint(equalTo: self.leftButton.topAnchor, constant: -10).isActive = true
        self.leftJumpButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.leftJumpButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.leftJumpButton.addTarget(self, action: #selector(jumpButtonTapped), for: .touchDown)
        
        // Once the UI is ready, let's make sure VoiceOver works properly
        self.handleVoiceOver()
    }
    
    @objc func handleVoiceOver() {
        if UIAccessibilityIsVoiceOverRunning() {
            // Hide the jump buttons
            self.rightJumpButton.alpha = 0
            self.leftJumpButton.alpha = 0
            
            self.rightButton.accessibilityLabel = "Move and jump right"
            self.leftButton.accessibilityLabel = "Move and jump left"
            self.arButton.accessibilityLabel = "Enter AR"
        } else {
            // Show the jump buttons
            self.rightJumpButton.alpha = 1
            self.leftJumpButton.alpha = 1
        }
    }
    
    func setupARButton() {
        self.view.addSubview(self.arButton)
        
        self.arButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.arButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        
        self.arButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        self.arButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.arButton.addTarget(self, action: #selector(arButtonTapped), for: .touchUpInside)
    }
    
    func setupLabels() {
        self.view.addSubview(self.fishCounterLabel)
        
        self.fishCounterLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        
        if #available (iOS 11.0, *), let page = self as? PlaygroundLiveViewSafeAreaContainer {
            self.fishCounterLabel.topAnchor.constraint(equalTo: page.liveViewSafeAreaGuide.topAnchor, constant: 10).isActive = true
        } else {
            self.fishCounterLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        }
    }
    
    // MARK: Onscreen UI Selectors
    
    @objc func jumpButtonTapped() {
        self.controlsDelegate?.jumpTapped()
    }
    
    @objc func leftButtonTapped() {
        if UIAccessibilityIsVoiceOverRunning() {
            self.controlsDelegate?.leftTappedVoiceOver()
            return
        }
        
        self.controlsDelegate?.leftTapped()
    }
    
    @objc func leftButtonReleased() {
        // VoiceOver triggers this properly
        self.controlsDelegate?.leftReleased()
    }
    
    @objc func rightButtonTapped() {
        if UIAccessibilityIsVoiceOverRunning() {
            self.controlsDelegate?.rightTappedVoiceOver()
            return
        }
        
        self.controlsDelegate?.rightTapped()
    }
    
    @objc func rightButtonReleased() {
        // VoiceOver triggers this properly
        self.controlsDelegate?.rightReleased()
    }
    
    @objc func arButtonTapped() {
        if #available(iOS 11.0, *) {
            if canOpenAR {
                let controller = ARViewController()
                controller.playerPosition = self.currentScene?.catNode?.position
                controller.activateCheckpoint = self.currentScene?.reachedCheckpoint
                self.present(controller, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "iOS 11 Required", message: "Please use a device that is running iOS 11.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: SpriteKit helpers/handlers
    
    func startScene(on view: SKView) {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill

            scene.parentViewController = self
            scene.rules = self.rules // Pass the given rules lower to the scene
            scene.shouldUseUIControls = true // UI controls should always be used

            view.presentScene(scene)

            self.currentScene = scene // Save this scene
            self.controlsDelegate = scene // Setup the controls delegate
        }
    }
    
    public func resetScene(atCheckpoint: Bool = false, atCatnip: Bool = false, canCatnipEndGame: Bool = false) {
        currentScene = nil

        if let view = self.view as! SKView? {
            startScene(on: view)
        }

        if atCheckpoint {
            // Handle checkpoint
            if let gameScene = self.currentScene {
                gameScene.resetFromCheckpoint()
            }
        } else if atCatnip {
            if let gameScene = self.currentScene {
                gameScene.resetFromCatnip(canCatnipEndGame: canCatnipEndGame)
            }
        }

        updateFishCount(fishCount: 0)
    }

    func updateFishCount(fishCount: Int) {
        self.fishCounterLabel.text = "\(fishCount) fish"
    }
    
    // MARK: Overriden variables
    
    override public var shouldAutorotate: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension GameViewController : PlaygroundLiveViewMessageHandler {
    
    open func receive(_ message: PlaygroundValue) {
        guard case let PlaygroundValue.dictionary(messageDictionary) = message else {
            return
        }
        
        guard let messageValue = messageDictionary["message"], case let PlaygroundValue.string(msg) = messageValue else {
            return
        }
        
        guard let bodyValue = messageDictionary["body"], case let PlaygroundValue.string(bodyString) = bodyValue else {
            return
        }
        
        if let bridgeValue = PlaygroundBridgeValue(rawValue: bodyString) {
            if msg != "update" {
                // Handle non-update data
                return
            }
            
            switch (bridgeValue) {
            case .addPlayer: // 02
                self.rules = [.noCatnip, .noCheckpoint, .noFish, .noJumping, .noMovement, .noSoundEffects, .noMusic]
                self.resetScene()
                break
            case .allowMovement: // 03
                self.rules = [.noCatnip, .noCheckpoint, .noFish, .noJumping, .noSoundEffects, .noMusic]
                break
            case .allowJumping: // 04
                self.rules = [.noCatnip, .noCheckpoint, .noFish, .noSoundEffects, .noMusic]
                break
            case .showFish: // 05
                self.rules = [.noCheckpoint, .noCatnip, .noSoundEffects, .noMusic]
                self.resetScene()
                break
            case .showFishCounter: // 05
                self.setupLabels()
                break
            case .addCheckpoint: // 06
                self.rules = [.noCatnip, .noSoundEffects, .noMusic]
                self.resetScene(atCheckpoint: true)
                
                self.currentScene?.canCheckpointActivate = false
                self.currentScene?.reachedCheckpoint = false
                break
            case .enableCheckpoint: // 06
                self.rules = [.noCatnip, .noSoundEffects, .noMusic]
                self.resetScene(atCheckpoint: true)
                break
            case .addCatnip: // 07
                self.rules = [.noSoundEffects, .noMusic]
                self.resetScene(atCatnip: true, canCatnipEndGame: true)
                
                self.currentScene?.canCatnipEndGame = false
                self.currentScene?.startAtCatnip = true
                break
            case .enableCatnip: // 07
                self.rules = [.noSoundEffects, .noMusic]
                self.resetScene(atCatnip: true, canCatnipEndGame: true)
                
                self.currentScene?.canCatnipEndGame = true
                self.currentScene?.startAtCatnip = true
                break
            case .allowSoundEffects: // 08
                self.rules = [.noMusic]
                break
            case .allowMusic: // 09
                self.rules = []
                self.resetScene()
                break
            case .showARButton: // 10
                self.showARButton = true
                self.setupARButton()
                break
            case .enableARButton: // 10
                self.canOpenAR = true
                break
            }
        }
    }
    
}

