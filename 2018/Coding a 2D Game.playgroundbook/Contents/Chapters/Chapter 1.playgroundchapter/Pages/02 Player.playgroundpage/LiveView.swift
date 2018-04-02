import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noPlayer, .noFish, .noMovement, .noJumping, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
