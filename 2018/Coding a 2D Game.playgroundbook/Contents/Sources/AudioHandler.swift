//
//  AudioHandler.swift
//  cat_game
//
//  Created by Jordan Osterberg on 3/16/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import Foundation
import SpriteKit

/// Wrapper for audio in SpriteKit
public class AudioHandler {
    
    public static let shared = AudioHandler()
    
    public var rules = [PlaygroundbookSceneRules]()
    
    /// Perform the appropriate action for the Sound provided.
    ///
    /// - Returns: If the provided sound is of the background type, an SKAudioNode will be returned. Otherwise nil will be returned. If
    @discardableResult
    func action(for sound: Sound, on scene: SKScene? = nil) -> SKAudioNode? {
        if sound.type == .background {
            if rules.contains(.noMusic) {
                return nil
            }
            
            guard let url = sound.fileURL else {
                return nil
            }
            
            let audioNode = SKAudioNode(url: url)
            audioNode.autoplayLooped = true
            return audioNode
        } else {
            if rules.contains(.noSoundEffects) {
                return nil
            }
            
            guard let fileName = sound.fileName else {
                return nil
            }
            
            if scene == nil {
                print ("WARNING: No scene was provided and the sound type was effect?")
            }
            
            DispatchQueue.global(qos: .background).async {
                scene?.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
            }
            
            return nil
        }
    }
    
}

/// Wrapper for sound files
public struct Sound {
    
    var type : SoundType!
    var fileURL : URL?
    var fileName : String?
    
    init(type: SoundType, fileUrl: URL? = nil, fileName: String? = nil) {
        self.type = type
        self.fileURL = fileUrl
        self.fileName = fileName
    }
    
}

/// SoundType
///
/// - background: Background sounds should play in the background of the scene, and should loop.
/// - effect: Effect sounds should play one time when an action occurs
public enum SoundType {
    
    case background
    case effect
    
}
