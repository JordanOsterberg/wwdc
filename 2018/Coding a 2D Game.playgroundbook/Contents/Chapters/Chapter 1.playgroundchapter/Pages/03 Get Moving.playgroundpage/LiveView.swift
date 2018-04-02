import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noFish, .noMovement, .noJumping, .noCatnip, .noCheckpoint, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
