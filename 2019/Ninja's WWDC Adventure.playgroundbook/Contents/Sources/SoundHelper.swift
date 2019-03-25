//
//  SoundHelper.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import SpriteKit

public class Sound {
    
    /// fileName should be in this format: filename.fileextension
    public var fileName: String
    public var type: SoundType
    
    /// Filename should be the complete file name, with extension
    public init(fileName: String, type: SoundType) {
        self.fileName = fileName
        self.type = type
    }
    
    /// Play on a scene
    /// If the returned value is nil, then the Sound is an effect and will play automatically
    /// If the returned value is not nil, then the object returned must be played by the scene manually
    @discardableResult public func play(on scene: SKScene) -> SKAudioNode? {
        if self.type == .soundEffect {
            DispatchQueue(label: "soundQueue", qos: .background).async {
                scene.run(SKAction.playSoundFileNamed(
                    String(self.fileName.split(separator: ".")[0]),
                    waitForCompletion: false))
            }
            
            return nil
        } else {
            let node = SKAudioNode(fileNamed: self.fileName)
            node.autoplayLooped = true
            return node
        }
    }
    
    /// The type of our Sound
    public enum SoundType {
        
        case soundEffect
        case backgroundMusic
        
    }
    
}

public extension GameScene {
    
    /// Return a node for a specific sound, if required
    @discardableResult public func node(for sound: Sound) -> SKAudioNode? {
        // TODO: Check if we're allowed to play specific sounds right now
        return sound.play(on: self)
    }
    
}
