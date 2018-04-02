import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noCatnip, .noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
