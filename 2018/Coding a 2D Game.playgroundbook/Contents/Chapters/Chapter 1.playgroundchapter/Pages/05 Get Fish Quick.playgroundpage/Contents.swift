//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

var fishAdded = false
var fish = 0

func addFish() {
    fishAdded = true
}

//#-end-hidden-code
/*:
 # Get Fish Quick
 
 Quick, let's get fish! First though, you need to learn about variables and integers.
 
 ## Variables
 [Variables](glossary://Variable) can store different values so we can use them later. The `cat` from the last two pages is a variable that has multiple functions. To create or "declare" variables, we type the keyword `var`.
 
 In this example, we have a variable called `fish`. To create this variable, we type
 
 
 `var fish = 0`
 
 We type `var`, we type the name of the variable, `fish`, and we set it equal to 0 with `= 0`.
 
 ## Integers
 
 An integer is a type of variable that stores number values. We can add one to the fish variable by typing:
 
 
 `fish += 1`
 
 This tells the iPad to add one to whatever value fish is equal to.
 
 * callout(Steps:):
 1. Use the `addFish()` function to add the fish into the level.
 2. Use `fish += 1` inside of the `catTouchedFish` function to add one to the fish integer [variable](glossary://Variable) every time a fish is collected.
 
 * callout(Goal:):
 Add the fish into the level, and add 1 to the fish integer when `catTouchedFish` is called.
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addFish(), fish, +=, 1)
// Add the fish into the level
//#-editable-code

//#-end-editable-code

func catTouchedFish() {
    // Add one to the fish integer
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code

catTouchedFish()

if fish == 1 && fishAdded {
    PlaygroundPageBridge.send(value: .showFishCounter)
    PlaygroundPageBridge.send(value: .showFish)
    
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Fishy! \n\n Try picking up a fish in the level! \n\n[Next Page](@next)")
} else {
    if fishAdded { // If the fish were added, update the controller
        PlaygroundPageBridge.send(value: .showFish)
    }
    
    fish = 0 // Reset fish just in case they did this part correctly and just didn't add the fish to the scene
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Make sure you added the fish into the level!", "Make sure you only add one to the `fish` integer when the player touches a fish."], solution: "Use the `addFish()` function, and inside of the `catTouchedFish` function, add one to the `fish` integer: \n\n`fish += 1`")
}
//#-end-hidden-code
