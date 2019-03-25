//
//  ButtonControlsViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/15/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class ButtonControlsViewController: UIViewController {
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Right Button"), for: .normal)
        button.accessibilityLabel = "Move and jump right"
        return button
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Left Button"), for: .normal)
        button.accessibilityLabel = "Move and jump left"
        return button
    }()
    
    let controlInteractionDelegate: ControlInteractionDelegate
    
    init(controlInteractionDelegate: ControlInteractionDelegate) {
        self.controlInteractionDelegate = controlInteractionDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)
        
        self.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchDown)
        self.rightButton.addTarget(self, action: #selector(rightButtonReleased), for: .touchUpInside)
        
        self.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchDown)
        self.leftButton.addTarget(self, action: #selector(leftButtonReleased), for: .touchUpInside)
        
        if #available(iOS 11.0, *) {
            self.rightButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
            self.leftButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        } else {
            self.rightButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
            self.leftButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        }
        
        self.rightButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        self.rightButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.rightButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.leftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        self.leftButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.leftButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    @objc func leftButtonTapped() {
        if UIAccessibility.isVoiceOverRunning || UIAccessibility.isSwitchControlRunning {
            self.controlInteractionDelegate.didJump()
        }
        
        self.controlInteractionDelegate.didMoveControl(in: .left)
    }
    
    @objc func rightButtonTapped() {
        if UIAccessibility.isVoiceOverRunning || UIAccessibility.isSwitchControlRunning {
            self.controlInteractionDelegate.didJump()
        }
        
        self.controlInteractionDelegate.didMoveControl(in: .right)
    }
    
    @objc func leftButtonReleased() {
        self.controlInteractionDelegate.didReleaseControl()
    }
    
    @objc func rightButtonReleased() {
        self.controlInteractionDelegate.didReleaseControl()
    }
    
}
