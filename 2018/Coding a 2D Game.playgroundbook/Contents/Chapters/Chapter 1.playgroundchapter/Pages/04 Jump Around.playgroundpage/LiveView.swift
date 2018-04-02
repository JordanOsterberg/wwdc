import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noFish, .noJumping, .noCatnip, .noCheckpoint, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
