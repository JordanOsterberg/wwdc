//
//  GameTimerDelegate.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/18/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import Foundation

protocol GameTimerDelegate {
    
    func stopTimer()
    func reset()
    func startTimer()
    func isOver() -> Bool
    
}
