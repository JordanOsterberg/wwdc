//#-hidden-code
import PlaygroundSupport
import UIKit

var buttonAdded = false
var mapAdded = false

func addARButton() {
    buttonAdded = true
    PlaygroundPageBridge.send(value: .showARButton)
}

func showARMap() {
    mapAdded = true
    PlaygroundPageBridge.send(value: .enableARButton)
}

//#-end-hidden-code
/*:
 # AR Map
 
 AR, or [augmented reality](glossary://Augmented%20Reality) is awesome and can be used to create unique functionality in our game.
 
 We're going to use AR in our game to allow the player to view the entire level in their living room as a map-- viewing how much of the level they have yet to complete.
 
 Here's what we have to do to enable AR in our game:
 
 * callout(Goal:):
 1. Call `addARButton()`
 2. Inside of the `arButtonTapped()` function, call the `showARMap()` function
 
 Press "Run my Code" when you've enabled AR!
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addARButton(), showARMap())
// Add the AR button here
//#-editable-code

//#-end-editable-code

func arButtonTapped() {
    // Show the AR map
    //#-editable-code
 
    //#-end-editable-code
}

//#-hidden-code
arButtonTapped()

if mapAdded && buttonAdded {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Mission Acomplished! \n\n And... done! Let's look at a recap of everything you've done! \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Make sure you add the button **and** show the AR map."], solution: "Use the `addARButton()` function to add the AR button, and show the AR map inside of the `arButtonTapped()` function with:\n\n`showARMap()`")
}
//#-end-hidden-code

