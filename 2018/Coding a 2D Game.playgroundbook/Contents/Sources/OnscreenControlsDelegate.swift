//
//  OnscreenControlsDelegate.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/16/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import Foundation

public protocol OnscreenControlsDelegate {
    
    func leftTapped()
    func leftReleased()
    func rightTapped()
    func rightReleased()
    func jumpTapped()
    
    // Accessibilty Helper
    func leftTappedVoiceOver()
    func rightTappedVoiceOver()
    
}
