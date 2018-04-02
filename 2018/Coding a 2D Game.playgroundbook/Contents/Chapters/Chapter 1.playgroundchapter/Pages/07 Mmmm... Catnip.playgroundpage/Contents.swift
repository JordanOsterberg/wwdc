//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

var catnipAdded = false
var isGameOver = false

func addCatnip() {
    catnipAdded = true
}

func gameOver() {
    isGameOver = true
}

//#-end-hidden-code
/*:
 # Mmmm... Catnip
 
 Isn't catnip just amazing? Cats love this stuff, and our orange tabby is no exception.
 
 Let's add the catnip into the level with `addCatnip()`, and call the `gameOver()` function when the player touches the catnip object.
 
 * callout(Steps:):
 1. Use the `addCatnip()` function to place the catnip in the level
 2. Inside the `catTouchedCatnip` function, call the `gameOver()` function
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, gameOver(), addCatnip())
// Add the catnip
//#-editable-code

//#-end-editable-code

func catTouchedCatnip() {
    // End the game
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code
catTouchedCatnip()

if catnipAdded && isGameOver {
    PlaygroundPageBridge.send(value: .addCatnip)
    PlaygroundPageBridge.send(value: .enableCatnip)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# You win!\n\nNow, we have a working game! When the cat touches the catnip, the game will end! Let's do a few things to spice up our game. \n\n[Next Page](@next)")
} else {
    if catnipAdded {
        PlaygroundPageBridge.send(value: .addCatnip)
    }
    
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you add the catnip to the scene and call the `gameOver()` function when the cat touches it."], solution: "Add the catnip to the level with `addCatnip()` and call the `gameOver()` function inside of the `catTouchedCatnip()` function.")
}

//#-end-hidden-code





