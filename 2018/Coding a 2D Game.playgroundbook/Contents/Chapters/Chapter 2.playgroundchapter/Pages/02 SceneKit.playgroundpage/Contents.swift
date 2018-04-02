//#-hidden-code
import PlaygroundSupport
import UIKit
import SceneKit

//#-end-hidden-code
/*:
 # SceneKit
 SpriteKit is great, but it only works for 2D games. Let's make something 3D!
 
 Similarly to SpriteKit, SceneKit also uses nodes, however they must include a `Geometry` object as input. In the example below, the `SCNText` is our input.
 
 We also have an action that rotates the node by 10 degrees on the x axis over a period of 5 seconds.
 
 Press "Run My Code" to try it out!
 
 */
let scene = SCNScene()
let view = SCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
view.backgroundColor = UIColor.clear

//#-editable-code
let text = SCNText(string: "Hello, Playgrounds!", extrusionDepth: 2)
text.font = UIFont.systemFont(ofSize: 10, weight: .regular)
text.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//#-end-editable-code

let node = SCNNode(geometry: text)
node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 10, y: 0, z: 0, duration: 5.0)))

scene.rootNode.addChildNode(node)

view.scene = scene

//#-hidden-code
PlaygroundPage.current.liveView = view
PlaygroundPage.current.assessmentStatus = .pass(message: "# Great! \n\n Change the contents of the diffuse (`text.firstMaterial?.diffuse.contents`) to change the text's color, or change the text itself. \n\n[Next](@next)")
//#-end-hidden-code
