//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

//#-end-hidden-code
/*:
 # SpriteKit
 Now that we've built our 2D game, let's look at some real code that allows us to create games on Apple platforms, like iPad. This portion of the book will dive directly into the code that drives our game. This chapter is designed to show you why programming is cool, and what you can do after learning and understanding difficult concepts in Swift.
 
 Before we fully dive into 3D and AR, let's talk about the tool that powers our 2D game, SpriteKit.
 
 SpriteKit allows for easy creation of 2D games by using [Scenes](glossary://SpriteKit%20Scene) which can be used to "house" [nodes](glossary://SpriteKit%20Node) which are objects within the scene. These nodes are considered "children" of the scene.
 
 Our game that we created in Chapter One was built using SpriteKit, however the code that you wrote wasn't directly tied to it. In this chapter you'll write real code that interacts with SpriteKit directly.
 
 In our game, the cat is a `PlayerNode` which is a custom node that is used to store information about the player, such as if it is touching the ground or not.
 
 Our PlayerNode is considered an "SKSpriteNode" because it has a texture, or [sprite](glossary://Sprite) attached to it. In this case, that's our orange tabby cat picture.
 
 Let's create a new [SpriteKit Scene](glossary://SpriteKit%20Scene) and add a SKSpriteNode to it.
 
 Press "Run My Code" to try it out!
 */

let scene = SKScene(size: CGSize(width: 500, height: 500))
let view = SKView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))

//#-editable-code
let node = SKSpriteNode(color: #colorLiteral(red: 0.239215686917305, green: 0.674509823322296, blue: 0.968627452850342, alpha: 1.0), size: CGSize(width: 250, height: 250))
//#-end-editable-code
node.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
scene.addChild(node)

scene.scaleMode = .aspectFill

view.presentScene(scene)

//#-hidden-code
PlaygroundPage.current.liveView = view
PlaygroundPage.current.assessmentStatus = .pass(message: "# Great! \n\n Try changing the color or size of the SKSpriteNode (width and height) and see what happens. \n\n[Next](@next)")
//#-end-hidden-code
