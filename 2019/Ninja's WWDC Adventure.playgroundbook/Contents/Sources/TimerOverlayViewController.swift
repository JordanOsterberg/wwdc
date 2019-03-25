//
//  TimerOverlayViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class TimerOverlayViewController: UIViewController, GameTimerDelegate {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = .layerMinXMaxYCorner
        }
        view.layer.cornerRadius = 25
        return view
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 46, weight: .medium)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.text = "2:30"
        return label
    }()
    
    var minute = 2
    var second = 30
    
    override public func viewDidLoad() {
        self.view.addSubview(self.backgroundView)
        
        self.backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.backgroundView.setHeight(equalTo: 160)
        self.backgroundView.setWidth(equalTo: 270)
        
        self.backgroundView.addSubview(self.timerLabel)

        self.timerLabel.centerVertically(in: self.backgroundView)
        self.timerLabel.centerHorizontally(in: self.backgroundView)
    }
    
    var timerAccessibilityString: String {
        if self.minute == 0 {
            return "\(self.second)second\(self.second == 1 ? "" : "s") remaining"
        } else {
            return "\(self.minute)minute\(self.minute == 1 ? "" : "s") and \(self.second)second\(self.second == 1 ? "" : "s") remaining"
        }
    }
    
    var timer: Timer?
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if self.second <= 0 {
                self.minute -= 1
                self.second = 60
                
                if self.minute < 0 {
                    VoiceOverHandler.shared.speak("The timer is over, Ninja is now late to WWDC")
                } else {
                    VoiceOverHandler.shared.speak(self.timerAccessibilityString)
                }
            }
            
            if ((self.second == 30 || self.second == 10) && self.minute == 0) {
                VoiceOverHandler.shared.speak(self.timerAccessibilityString)
            }
            
            if self.minute < 0 {
                timer.invalidate()
                return
            }
            
            self.second -= 1
            
            if self.second < 10 {
                self.timerLabel.text = "\(self.minute):0\(self.second)"
            } else {
                self.timerLabel.text = "\(self.minute):\(self.second)"
            }
            
            self.timerLabel.accessibilityLabel = self.timerAccessibilityString
        })
    }
    
    func isOver() -> Bool {
        return self.minute < 0
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func reset() {
        self.timer?.invalidate()
        
        self.minute = 2
        self.second = 30
        self.timerLabel.text = "2:30"
    }
    
}
