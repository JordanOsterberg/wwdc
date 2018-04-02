//#-hidden-code
import PlaygroundSupport
import UIKit
import SceneKit

//#-end-hidden-code
/*:
 # Our Game in 3D
 
 Let's take our newfound knowledge of SceneKit and SpriteKit and place our game's scene on a box in our SceneKit scene.
 */
let scene = SCNScene()
let view = SCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
view.backgroundColor = UIColor.clear

let gameScene = GameScene(fileNamed: "GameScene") // Load our 2D game's SpriteKit scene
gameScene?.scaleMode = .aspectFit

// Create a 125x50x50 box
//#-editable-code
let box = SCNBox(width: 125, height: 50, length: 50, chamferRadius: 1)
//#-end-editable-code

box.firstMaterial?.diffuse.contents = gameScene // Set the texture to our SpriteKit scene
box.firstMaterial?.isDoubleSided = true // Make sure our scene shows up on both sides

let node = SCNNode(geometry: box) // Create the node

node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 10, y: 10, z: 0, duration: 10.0)))

scene.rootNode.addChildNode(node)

view.scene = scene

//#-hidden-code
PlaygroundPage.current.liveView = view
PlaygroundPage.current.assessmentStatus = .pass(message: "# Awesome! \n\n Try changing the box's width, height, and length. You can also alter the chamferRadius to round the corners of the box. \n\n[Next](@next)")
//#-end-hidden-code
