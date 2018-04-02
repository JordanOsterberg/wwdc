//#-hidden-code
import PlaygroundSupport
import UIKit
import SceneKit
import SpriteKit

let gameScene = SKScene()

PlaygroundPage.current.assessmentStatus = .pass(message: "# And that's it! \n\n Those are the basic Fundamentals of creating games for iPad and iPhone! I hope you enjoyed this Playground, and I hope to see you at WWDC2018 🤟🏻😁")

let controller = GameViewController()
controller.showARButton = true
PlaygroundPage.current.liveView = controller
//#-end-hidden-code
/*:
 # 3D to AR
 
 Like you saw towards the end of Chapter One, AR can be used to enhance our game and provide functionality, such as a map of the entire level-- here's a snippet of the code that powers that functionality. It uses SceneKit to place our Game on an `SCNPlane`, then places that plane into your living room!
 */
    
let plane = SCNPlane(width: 2, height: 1)

plane.firstMaterial?.diffuse.contents = gameScene // Set the texture to our SpriteKit scene
plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0) // Make it right side up
plane.firstMaterial?.isDoubleSided = true // Make sure our scene shows up on both sides

let node = SCNNode(geometry: plane) // Create the node
