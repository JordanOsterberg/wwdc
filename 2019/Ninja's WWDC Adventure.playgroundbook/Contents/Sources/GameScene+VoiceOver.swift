//
//  GameScene+VoiceOver.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/18/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    var voiceOverNodes: [SKNode] {
        get {
            var nodes: [SKNode] = []
            
            for child in self.children.filter({
                return $0.name?.lowercased().contains("voiceover") == true
            }) {
                nodes.append(child)
            }
            
            return nodes
        }
    }
    
    func handleVoiceOver(for node: SKNode) {
        let message = self.message(for: node.name ?? "VoiceOver|x")
        
        guard !message.isEmpty else {
            return
        }
        
        VoiceOverHandler.shared.speak(message)
    }
    
    fileprivate func message(for nodeName: String) -> String {
        switch nodeName.split(separator: "|")[1] {
        case "STARTING_POSITION":
            return "Background: Ninja the cat is in a big city. Move him to the left, and find the 3 ticket pieces he lost."
        case "LARGE_ROAD":
            return "Background: Road with cars in 6 colors driving by."
        case "APPLE_STORE":
            return "Background: Apple Store with tables. Store wallpaper shows WWDC 2019 artwork."
        case "FORESTER_SLEEPING":
            if self.carrotCollected || self.carrotDelivered {
                return "Background: Forester the dog is still asleep. You gave him a carrot, and he is happy. Good job!"
            }
            
            return "Background: Forester the dog is asleep. He would like a carrot. You can find one to the far right of the city."
        case "TIM_BANNER":
            return "Background: Tim Cook Animoji on billboard reading \"Welcome to WWDC19\""
        case "NEON_WWDC_BANNER":
            if !self.voiceOverWWDCBannerText.isEmpty {
                return self.voiceOverWWDCBannerText // If there is custom text VoiceOver users have entered for the banner
            }
            
            return "Background: WWDC Banner. Monkey, Alien, Skull, and Robot Animojis in neon lighting. Caption reads: Write Code Blow Minds"
        case "CRAIG_MESSAGE":
            if self.ticketsCollected == 3 {
                return "Background: Craig says: Awe! What a cute cat you are. Come right in, so glad you could make it!"
            }
            
            return "Background: Craig says: Sorry, but I can't let you in, even if you're an adorable cat. If you can get a ticket, we can let you in!"
        default: return ""
        }
    }
    
}
