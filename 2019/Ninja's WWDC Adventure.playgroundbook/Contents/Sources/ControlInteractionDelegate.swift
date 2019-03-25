//
//  ControlInteractionDelegate.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public protocol ControlInteractionDelegate {
    
    func didMoveControl(in direction: Direction)
    func didJump()
    func didReleaseControl()
    
}
