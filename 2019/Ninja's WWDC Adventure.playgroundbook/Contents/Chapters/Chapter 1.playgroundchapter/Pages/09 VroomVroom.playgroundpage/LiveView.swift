import PlaygroundSupport

let controller = PrimaryViewController()

controller.allowHorizontalMovement = true
controller.allowJumping = true
controller.shouldDisplayTickets = true
controller.allowTicketPickup = true
controller.shouldPlayMusic = true
controller.shouldShowCars = false
controller.shouldShowCarrot = false

PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true

if let keyValue = PlaygroundKeyValueStore.current["backgroundMusic"], case .string(let backgroundMusicName) = keyValue {
    controller.gameScene.backgroundMusicSound = Sound(fileName: backgroundMusicName, type: .backgroundMusic)
}
