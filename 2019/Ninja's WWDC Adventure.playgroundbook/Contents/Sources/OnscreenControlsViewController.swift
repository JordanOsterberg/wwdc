//
//  OnscreenControlViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class OnscreenControlsViewController: UIViewController {
    
    lazy var joystickController = JoystickControlsViewController(controlInteractionDelegate: self.controlInteractionDelegate)
    lazy var buttonController = ButtonControlsViewController(controlInteractionDelegate: self.controlInteractionDelegate)
    
    let controlInteractionDelegate: ControlInteractionDelegate
    
    init(controlInteractionDelegate: ControlInteractionDelegate) {
        self.controlInteractionDelegate = controlInteractionDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLoad() {
        self.controlStyleChanged()
        
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(controlStyleChanged), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(controlStyleChanged), name: UIAccessibility.switchControlStatusDidChangeNotification, object: nil)
        }
    }
    
    @objc func controlStyleChanged() {
        if UIAccessibility.isVoiceOverRunning || UIAccessibility.isSwitchControlRunning {
            self.add(self.buttonController)
            self.joystickController.remove()
        } else {
            self.add(self.joystickController)
            self.buttonController.remove()
        }
    }
    
}
