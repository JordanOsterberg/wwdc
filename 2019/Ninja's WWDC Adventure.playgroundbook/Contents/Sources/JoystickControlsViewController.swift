//
//  JoystickControlsViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/15/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class JoystickControlsViewController: UIViewController {
    
    let controlInteractionDelegate: ControlInteractionDelegate
    
    init(controlInteractionDelegate: ControlInteractionDelegate) {
        self.controlInteractionDelegate = controlInteractionDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var joystickView = JoystickView(delegate: self.controlInteractionDelegate)
    
    public override func viewDidLoad() {
        self.view.addSubview(self.joystickView)
        
        if #available(iOS 11.0, *) {
            self.joystickView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            self.joystickView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        } else {
            self.joystickView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.joystickView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        }
    }
    
}
