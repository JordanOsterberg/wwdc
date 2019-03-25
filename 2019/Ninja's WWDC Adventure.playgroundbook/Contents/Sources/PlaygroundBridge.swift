import PlaygroundSupport

public class PlaygroundBridge {
    
    public class func send(_ message: PlaygroundBridgeMessage, data: String = "") {
        let liveController = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
        
        let dictionary: [String : PlaygroundValue] = ["message" : PlaygroundValue.string(message.rawValue), "body" : PlaygroundValue.string(data)]
        
        liveController?.send(PlaygroundValue.dictionary(dictionary))
    }
    
}

public enum PlaygroundBridgeMessage: String {
    
    case joystickUpdates
    case jumping
    case addTickets
    case allowTicketPickup
    case backgroundMusic
    case addCars
    case carDuration
    case addCarrot
    case voiceOverBanner
    
}

extension PrimaryViewController: PlaygroundLiveViewMessageHandler {
    
    open func receive(_ message: PlaygroundValue) {
        guard case let PlaygroundValue.dictionary(messageDictionary) = message else {
            return
        }
        
        guard let message = messageDictionary["message"], case let PlaygroundValue.string(messageValue) = message, let bridgeMessage = PlaygroundBridgeMessage(rawValue: messageValue) else {
            return
        }
        
        guard let bodyValue = messageDictionary["body"], case let PlaygroundValue.string(bodyString) = bodyValue else {
            return
        }
        
        switch bridgeMessage {
        case .joystickUpdates:
            guard !bodyString.isEmpty else {
                return
            }
            
            let directionForLeft = bodyString.split(separator: "|")[0]
            let directionForRight = bodyString.split(separator: "|")[1]
            
            if directionForLeft != "left" {
                self.switchLeftJoystick = true
            }
            
            if directionForRight != "right" {
                self.switchRightJoystick = true
            }
            
            self.allowHorizontalMovement = true
            break
        case .jumping:
            self.allowJumping = true
            break
        case .addTickets:
            self.shouldDisplayTickets = true
            break
        case .allowTicketPickup:
            self.allowTicketPickup = true
            break
        case .backgroundMusic:
            self.shouldPlayMusic = true
            self.gameScene.backgroundMusicSound = Sound(fileName: bodyString, type: .backgroundMusic)
            break
        case .addCars:
            self.shouldShowCars = true
            break
        case .carDuration:
            let proposedDuration = Int(bodyString) ?? 4
            self.carDuration = Double(proposedDuration)
            break
        case .addCarrot:
            self.shouldShowCarrot = true
            break
        case .voiceOverBanner:
            self.voiceOverWWDCBannerText = bodyString
            break
        }
    }
    
}
