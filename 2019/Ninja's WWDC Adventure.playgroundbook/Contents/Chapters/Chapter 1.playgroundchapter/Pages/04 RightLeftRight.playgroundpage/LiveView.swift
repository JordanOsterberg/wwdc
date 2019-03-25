import PlaygroundSupport

let controller = PrimaryViewController()

controller.allowHorizontalMovement = false
controller.allowJumping = false
controller.shouldDisplayTickets = false
controller.allowTicketPickup = false
controller.shouldShowCars = false
controller.shouldShowCarrot = false
controller.shouldPlayMusic = false

PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
