//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

var passed = false

func addPlayer() { // This is here to prevent errors in the playground
    PlaygroundPageBridge.send(value: .addPlayer)
    passed = true
}

//#-end-hidden-code
/*:
 # The Player
 Every game needs a player, and ours is a cat. In Swift we use [functions](glossary://Function) to perform actions on the screen. You can "call" or use a function by typing it's name. In this case the name is "addPlayer", and we can call the function by adding opening and closing parentheses to the end like this: `addPlayer()`
 
 * callout(Goal:):
 Call the `addPlayer()` function to add the player to the scene.
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addPlayer())
// Call the addPlayer function here
//#-editable-code

//#-end-editable-code

//#-hidden-code
if passed {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Awesome! \n\n The cat is in the scene. Let's make him move! \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you spell and capitalize everything correctly."], solution: "Call the `addPlayer()` function")
}
//#-end-hidden-code
