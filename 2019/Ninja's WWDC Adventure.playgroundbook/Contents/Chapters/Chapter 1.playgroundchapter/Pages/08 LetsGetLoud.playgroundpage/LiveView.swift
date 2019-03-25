import PlaygroundSupport

let controller = PrimaryViewController()

controller.allowHorizontalMovement = true
controller.allowJumping = true
controller.shouldDisplayTickets = true
controller.allowTicketPickup = true
controller.shouldPlayMusic = false
controller.shouldShowCars = false
controller.shouldShowCarrot = false

PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
