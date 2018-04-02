//
//  VoiceOverHandler.swift
//  VoiceOverSystem
//
//  Created by Jordan Osterberg on 3/29/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import UIKit

public class VoiceOverHandler {
    
    public static let shared = VoiceOverHandler()

    public func speak(_ text: String) {
        if #available(iOS 11.0, *) {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, NSAttributedString(string: text, attributes: [NSAttributedStringKey(rawValue: UIAccessibilitySpeechAttributeQueueAnnouncement) : true]))
        } else {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
        }
    }
    
}
