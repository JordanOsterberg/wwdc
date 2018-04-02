//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

var checkpointActive = false
var checkpointAdded = false

func addCheckpoint() {
    checkpointAdded = true
}

//#-end-hidden-code
/*:
 # Checkpoint!
 
 Do you know the feeling of being **so** close to the end of the level only to fall off the last platform and be sent back to the start?
 
 Let's take some weight off of the player's shoulders and add a checkpoint so they don't start over from scratch.
 
 ## Booleans
 
 To do this, we need to learn about booleans. Booleans are a type of variable that can be `true` or `false`. In this case, we have a boolean named `checkpointActive` that represents our checkpoint's status. If it's set to `true`, it means the checkpoint is active. To change the value of a boolean, just type its name followed by `= true` or `= false`:
 
 
 `checkpointActive = true`
 
 * callout(Steps:):
 1. Use the `addCheckpoint()` function to place the checkpoint in the level
 2. Inside the `catTouchedCheckpoint` function, set `checkpointActive` equal to true by using `checkpointActive = true`
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addCheckpoint(), checkpointActive, =, false, true)
// Add the checkpoint into the level
//#-editable-code

//#-end-editable-code

func catTouchedCheckpoint() {
    // Activate the checkpoint
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code
catTouchedCheckpoint()

if checkpointAdded && checkpointActive {
    PlaygroundPageBridge.send(value: .addCheckpoint)
    PlaygroundPageBridge.send(value: .enableCheckpoint)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Checkpoint! \n\n If our cat falls off the platform into the lava, no problem! \n\n[Next Page](@next)")
} else {
    if checkpointAdded {
        PlaygroundPageBridge.send(value: .addCheckpoint)
    }
    
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you add the checkpoint to the scene and activate it."], solution: "Add the checkpoint to the level with `addCheckpoint()`, and activate the checkpoint: \n\n`checkpointActive = true`")
}

//#-end-hidden-code





