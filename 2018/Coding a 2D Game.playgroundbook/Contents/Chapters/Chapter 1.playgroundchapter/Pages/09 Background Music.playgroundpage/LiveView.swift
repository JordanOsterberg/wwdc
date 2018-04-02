import PlaygroundSupport

let controller = GameViewController()
controller.rules = [.noMusic]
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
