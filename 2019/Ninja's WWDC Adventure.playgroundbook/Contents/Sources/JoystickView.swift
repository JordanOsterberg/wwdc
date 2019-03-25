//
//  JoystickView.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class JoystickView: UIView {
    
    lazy var grabberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = self.grabberWidthAndHeight / 2
        view.clipsToBounds = false
        return view
    }()

    var delegate: ControlInteractionDelegate
    
    fileprivate var widthAndHeight: CGFloat = 95
    fileprivate var grabberWidthAndHeight: CGFloat = 60
    
    public init(delegate: ControlInteractionDelegate) {
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
        
        self.isUserInteractionEnabled = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setWidth(equalTo: self.widthAndHeight)
        self.setHeight(equalTo: self.widthAndHeight)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.layer.cornerRadius = self.widthAndHeight / 2
        self.clipsToBounds = false
        
        self.addSubview(self.grabberView)
        
        self.grabberView.centerVertically(in: self)
        self.grabberView.centerHorizontally(in: self)
        self.grabberView.setWidth(equalTo: grabberWidthAndHeight)
        self.grabberView.setHeight(equalTo: grabberWidthAndHeight)
        
        self.setupGuesterRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGuesterRecognizer() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanGrabber))
        self.grabberView.isUserInteractionEnabled = true
        self.grabberView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func didPanGrabber(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self)
            
            var newX = self.grabberView.center.x
            var newY = self.grabberView.center.y
            
            let proposedX = self.grabberView.center.x + translation.x
            let proposedY = self.grabberView.center.y + translation.y
            
            if proposedX >= 0 && proposedX <= (self.widthAndHeight - 20) {
                newX = proposedX
            }
            
            if proposedY >= 0 && proposedY <= (self.widthAndHeight - 20) {
                newY = proposedY
            }
            
            self.grabberView.center = CGPoint(x: newX,
                                              y: newY)
            
            recognizer.setTranslation(.zero, in: self)
            
            if newX <= self.widthAndHeight / 2 {
                self.delegate.didMoveControl(in: .left)
            } else {
                self.delegate.didMoveControl(in: .right)
            }
            
            if newY <= (self.widthAndHeight / 2) - 30 {
                self.delegate.didJump()
            }
        case .ended, .cancelled, .failed:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.grabberView.center = CGPoint(x: self.widthAndHeight / 2, y: self.widthAndHeight / 2)
            }, completion: nil)

            self.delegate.didReleaseControl()
        default:
            break
        }
    }
    
}
