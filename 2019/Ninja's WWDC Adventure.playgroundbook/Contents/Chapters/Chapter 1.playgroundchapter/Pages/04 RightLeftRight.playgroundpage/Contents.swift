//#-hidden-code
import PlaygroundSupport

var passed = true

var directionForLeftJoystick = "left"
var directionForRightJoystick = "right"

var movedLeft = false
var movedRight = false

func moveNinjaLeft() {
    movedLeft = true
}

func moveNinjaRight() {
    movedRight = true
}

//#-end-hidden-code
/*:
 # ➡ Right, Left, Right!
 Oh no! 😱 Shocked by losing his ticket to WWDC, it looks like Ninja has forgotten how to move! Let's give him a hand. 🙌
 
 To help Ninja move, we need to learn about [functions](glossary://Function). Functions are little pieces of code that we can use at any time.
 
 Let's take a look at a function:
 
 ```
 func didMoveJoystickLeft() {
    // 🕸 Not much to see here...
 }
 ```
 
 This function's name is ```didMoveJoystickLeft```.
 
 To use a function, type the name of the function, followed by parentheses: ```functionName()```.
 
 ## Goal
 * callout(Goal:):
 1. Inside of the ```didMoveJoystickLeft``` and the ```didMoveJoystickRight``` functions, we're going to move Ninja. You can move Ninja by using the ```moveNinjaLeft``` and ```moveNinjaRight``` functions.
 
 When you're ready to test your code, go ahead and press "Run my code".
 
 💡 **Tip:** If your code doesn't work, you'll be able to see the solution.
*/

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, moveNinjaLeft(), moveNinjaRight())

func didMoveJoystickLeft() {
    // Move Ninja left
    //#-editable-code
    <#moveNinjaLeft()#>
    //#-end-editable-code
}

func didMoveJoystickRight() {
    // Move Ninja right
    //#-editable-code
    <#moveNinjaRight()#>
    //#-end-editable-code
}

//#-hidden-code

movedLeft = false
movedRight = false

didMoveJoystickLeft()
if !movedLeft && !movedRight {
    passed = false
} else {
    // Handle the case where they decice to mix and match...
    if movedRight {
        directionForLeftJoystick = "right"
    }
}

movedLeft = false
movedRight = false

didMoveJoystickRight()
if !movedLeft && !movedRight {
    passed = false
} else {
    // Handle the case where they decice to mix and match...
    if movedLeft {
        directionForRightJoystick = "left"
    }
}

if passed {
    PlaygroundBridge.send(.joystickUpdates, data: "\(directionForLeftJoystick)|\(directionForRightJoystick)")
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Horizontal! \n\n Ninja has regained his ability to move left and right! Next up, we'll help him re-learn how to jump. \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "Type ```moveNinjaLeft()``` inside of ```didMoveJoystickLeft```, and type ```moveNinjaRight()``` inside of ```didMoveJoystickRight```.")
}

//#-end-hidden-code
