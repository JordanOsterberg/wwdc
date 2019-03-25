//
//  CoinCounterDelegate.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import Foundation
import SpriteKit

protocol ItemCollectionDelegate {
    
    func didCollect(item: Item, on scene: SKScene?)
    func reset()
    
}

public enum Item {
    
    case ticketOne
    case ticketTwo
    case ticketThree
    case carrot
    
}
