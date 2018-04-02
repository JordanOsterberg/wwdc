//
//  Array+Extension.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/16/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import Foundation

public extension Array {
    
    /// Access a random Element in the array
    var random : Element {
        get {
            return self[Int(arc4random_uniform(UInt32(self.count)))]
        }
    }
    
}
