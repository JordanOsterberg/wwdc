//
//  VoiceOverHandler.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

public class VoiceOverHandler {
    
    public static let shared = VoiceOverHandler()
    
    public func speak(_ text: String) {
        if #available(iOS 11.0, *) {
            UIAccessibility.post(notification: .announcement, argument: NSAttributedString(string: text, attributes: [.accessibilitySpeechQueueAnnouncement : true]))
        } else {
            UIAccessibility.post(notification: .announcement, argument: text)
        }
    }
    
}
