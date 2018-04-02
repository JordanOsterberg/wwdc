import PlaygroundSupport

public class PlaygroundPageBridge {
    
    public class func send(value: PlaygroundBridgeValue) {
        let liveController = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
        
        let dictionary : [String : PlaygroundValue] = ["message" : PlaygroundValue.string("update"), "body" : PlaygroundValue.string(value.rawValue)]

        liveController?.send(PlaygroundValue.dictionary(dictionary))
    }
    
}

public enum PlaygroundBridgeValue : String {
    
    case addPlayer
    case allowMovement
    case allowJumping
    
    case showFish
    case showFishCounter
    
    case addCheckpoint
    case enableCheckpoint
    
    case addCatnip
    case enableCatnip
    
    case allowSoundEffects
    case allowMusic
    
    case showARButton
    case enableARButton
    
}
