import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noFish, .noCatnip, .noCheckpoint, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
