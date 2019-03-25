//
//  ViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit
import SpriteKit

/// The container for all of the component controllers
public class PrimaryViewController: UIViewController {

    /// Debug mode will show info about the game's performance
    fileprivate var debugMode: Bool = false
    
    /// gameView houses our GameScene
    lazy var gameView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.ignoresSiblingOrder = true
        view.allowsTransparency = true
        view.showsFPS = debugMode
        view.showsNodeCount = debugMode
        view.showsPhysics = debugMode
        return view
    }()
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// Displays the current amount of coins the player has
    lazy var coinOverlayController = ItemOverlayViewController()
    
    /// Displays the time remaining in the game before the player loses
    lazy var timerOverlayController = TimerOverlayViewController()
    
    /// Handles keyboard input for iPad Pro's Smart Keyboard... kinda
    /// WebKit doesn't play nice with Playgrounds, so this doesn't work in Playgrpunds.
    /// In the event it does work, it's here.
    lazy var webKitKeyboardController = WebKitKeyboardViewController(controlInteractionDelegate: self)
    
    /// Shows and processes on-screen joystick (or buttons for Accessibility users) controls input
    lazy var onscreenControlsViewController = OnscreenControlsViewController(controlInteractionDelegate: self)
    
    /// Cache the current gameScene as an optional
    fileprivate var __gameScene: GameScene?
    
    /// Uses a computed property instead of a saved variable in order to remove typically ugly optionals 😅
    public var gameScene: GameScene {
        get {
            if let scene = self.__gameScene {
                return scene
            }
            
            if let scene = GameScene(fileNamed: "GameScene.sks") {
                scene.scaleMode = .aspectFill
                scene.itemDelegate = self.coinOverlayController
                scene.timerDelegate = self.timerOverlayController
                scene.gameCompletedCompletionHandler = self.gameCompletedCompletionHandler
                scene.introductionCompletedHandler = self.introductionCompletedHandler
                scene.backgroundMusicAllowed = self.shouldPlayMusic
                
                self.__gameScene = scene
                return scene
            } else {
                fatalError("Failed to load GameScene")
            }
        }
    }
    
    /// This function is called when the game is completed.
    lazy var gameCompletedCompletionHandler: (() -> Void) = {
        UIView.animate(withDuration: 0.4, animations: {
            self.coinOverlayController.view.alpha = 0
            self.timerOverlayController.view.alpha = 0
            self.onscreenControlsViewController.view.alpha = 0
        })
        
        let gameOverController = GameOverOverlayController(onTime: !self.timerOverlayController.isOver(), carrotFed: self.gameScene.carrotDelivered, playAgainCompletionHandler: {
            UIView.animate(withDuration: 0.4, animations: {
                self.coinOverlayController.view.alpha = 1
                self.timerOverlayController.view.alpha = 1
                self.onscreenControlsViewController.view.alpha = 1
            })
            
            self.coinOverlayController.reset()
            self.timerOverlayController.reset()
            self.__gameScene = nil
            self.gameView.presentScene(self.gameScene)
        })
        self.present(gameOverController, animated: true, completion: nil)
    }
    
    lazy var introductionCompletedHandler: (() -> Void) = {
        UIView.animate(withDuration: 0.4, animations: {
            self.coinOverlayController.view.alpha = 1
            self.timerOverlayController.view.alpha = 1
            self.onscreenControlsViewController.view.alpha = 1
        })
    }
    
    override public func viewDidLoad() {
        self.view.addSubview(self.gameView)
        self.gameView.sameSizeAs(self.view)
        
        self.gameView.presentScene(self.gameScene)
        
        self.add(self.coinOverlayController)
        self.add(self.timerOverlayController)
        
        self.add(self.webKitKeyboardController) // This doesn't work in Playgrounds :(
        self.add(self.onscreenControlsViewController) // This MUST be highest on the hierarchy
        
        if self.gameScene.showIntroduction && !UIAccessibility.isVoiceOverRunning {
            self.coinOverlayController.view.alpha = 0
            self.timerOverlayController.view.alpha = 0
            self.onscreenControlsViewController.view.alpha = 0
        }
    }
    
    /// If false, horizontal movement will be disabled. Defaults to true.
    public var allowHorizontalMovement = true
    
    /// If false, jumping will be disabled. Defaults to true.
    public var allowJumping = true
    
    /// If true, didMoveControl will switch the direction value when it is left
    public var switchLeftJoystick = false
    
    /// If true, didMoveControl will switch the direction value when it is right
    public var switchRightJoystick = false
    
    /// If true, tickets will display in the GameScene
    public var shouldDisplayTickets = true {
        didSet {
            if shouldDisplayTickets {
                self.gameScene.showTickets()
            } else {
                self.gameScene.hideTickets()
            }
        }
    }
    
    /// If true, tickets will be pick-up-able in the GameScene
    public var allowTicketPickup = true {
        didSet {
            self.gameScene.allowTicketPickup = allowTicketPickup
        }
    }
    
    /// If true, cars will display in the GameScene
    public var shouldShowCars = true {
        didSet {
            self.gameScene.shouldShowCars = shouldShowCars
        }
    }
    
    public var carDuration = 4.0 {
        didSet {
            self.gameScene.carDuration = carDuration
        }
    }
    
    /// If true, the carrot will display in the GameScene
    public var shouldShowCarrot = true {
        didSet {
            self.gameScene.shouldShowCarrot = self.shouldShowCarrot
        }
    }
    
    /// If true, background music will play
    public var shouldPlayMusic = true {
        didSet {
            self.gameScene.backgroundMusicAllowed = self.shouldPlayMusic
        }
    }
    
    public var voiceOverWWDCBannerText: String = "" {
        didSet {
            self.gameScene.voiceOverWWDCBannerText = self.voiceOverWWDCBannerText
        }
    }
    
}

extension PrimaryViewController: ControlInteractionDelegate {
    
    public func didMoveControl(in direction: Direction) {
        if !self.allowHorizontalMovement {
            return
        }
        
        if direction == .left && self.switchLeftJoystick {
            self.gameScene.didMoveControl(in: .right)
            return
        }
        
        if direction == .right && self.switchRightJoystick {
            self.gameScene.didMoveControl(in: .left)
            return
        }
        
        self.gameScene.didMoveControl(in: direction)
    }
    
    public func didJump() {
        if !self.allowJumping {
            return
        }
        
        self.gameScene.didJump()
    }
    
    public func didReleaseControl() {
        self.gameScene.didReleaseControl()
    }
    
}
