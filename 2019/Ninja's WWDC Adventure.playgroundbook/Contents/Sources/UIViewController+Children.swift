//
//  UIViewController+Children.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Add 'child' to the caller view controller
    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Remove this view controller from its parent
    func remove() {
        guard self.parent != nil else {
            return
        }
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
