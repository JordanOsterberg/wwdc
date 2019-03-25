import PlaygroundSupport

let controller = PrimaryViewController()
controller.gameScene.showIntroduction = true
PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true
