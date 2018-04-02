import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noCatnip, .noCheckpoint, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
