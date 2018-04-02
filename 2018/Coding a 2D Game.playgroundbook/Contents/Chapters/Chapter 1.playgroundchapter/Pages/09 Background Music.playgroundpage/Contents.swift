//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

func startBackgroundMusic() {
    PlaygroundPageBridge.send(value: .allowMusic)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Musical! \n\n Music makes our game feel much more lively. Our game is almost complete! There's just one more thing that will be the icing on the cake...\n\n[Next Page](@next)")
}

//#-end-hidden-code
/*:
 # Background Music
 Every game needs a soundtrack. Let's play some music when our game starts!
 
 * callout(Goal:):
 1. Call `startBackgroundMusic()` when the `gameStarted` function is called.
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, startBackgroundMusic())
func gameStarted() {
    // Start the background music
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code
gameStarted()
//#-end-hidden-code
