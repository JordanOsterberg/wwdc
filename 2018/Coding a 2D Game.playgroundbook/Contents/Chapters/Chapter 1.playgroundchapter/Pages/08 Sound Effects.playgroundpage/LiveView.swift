import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noSoundEffects, .noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
