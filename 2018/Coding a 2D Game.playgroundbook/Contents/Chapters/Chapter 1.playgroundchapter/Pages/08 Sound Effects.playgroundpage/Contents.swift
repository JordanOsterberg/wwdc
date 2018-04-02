//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

enum Sound {
    case ding
    case groan
    case meow
    case none
}

var latestSoundPlayed : Sound = .none

func playSound(_ sound: Sound) {
    latestSoundPlayed = sound
}

func check() -> Bool {
    catTouchedFish()
    
    if latestSoundPlayed != .ding {
        return false
    }
    
    gameWin()
    
    if latestSoundPlayed != .meow {
        return false
    }
    
    gameLose()
    
    if latestSoundPlayed != .groan {
        return false
    }
    
    catTouchedCheckpoint()
    
    if latestSoundPlayed != .ding {
        return false
    }
    
    return true // We've made it!
}

//#-end-hidden-code
/*:
 # Sound Effects
 Our game is complete, but we can spice it up with some sound effects. Let's play some sound effects when different events occur!
 
 🔈 Make sure you turn up your volume and enable alert sounds from Control Center for the full experience!
 
 ## Parameters
 
 To do this, we need to learn about function parameters. Previously, we've learned about functions that do just one function with no parameters. Adding parameters to functions can allow functions to provide different functions for different parmaters.
 
 Using parameters is easy: Just call the function like normal, and inside the parathenses type the value you want to use.. Playing sounds is easy with parameters, just use: `playSound(.ding)`
 
 The sound can be `.ding`, `.meow`, and `.groan`.
 
 > The first sound is already done for you, inside of `catTouchedFish`.
 
 * callout(Goal:):
 1. Inside of the `gameWin` function, play the `.meow` sound
 2. Inside of the `gameLose` function, play the `.groan` sound
 3. Inside of the `catTouchedCheckpoint` the `.ding`
 */

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, latestSoundPlayed, check(), catTouchedFish(), catTouchedCheckpoint(), gameWin(), gameLose())

func catTouchedFish() {
    // Play the .ding sound
   playSound(.ding)
}

func catTouchedCheckpoint() {
    // Play the .ding sound
    //#-editable-code
    playSound(<#T##Sound##Sound#>)
    //#-end-editable-code
}

func gameWin() {
    // Play the .meow sound
    //#-editable-code
    playSound(<#T##Sound##Sound#>)
    //#-end-editable-code
}

func gameLose() {
    // Play the .groan sound
    //#-editable-code
    playSound(<#T##Sound##Sound#>)
    //#-end-editable-code
}

//#-hidden-code
if check() {
    PlaygroundPageBridge.send(value: .allowSoundEffects)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Resounding! \n\n Those small sound effects make our game so much more lively! There's just one more thing we should do... \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you play all 4 sounds, and make sure they all play at the right time."], solution: "To play a sound use the `playSound` function. For example, to play the ding sound you type:\n\n`playSound(.ding)`")
}
//#-end-hidden-code

