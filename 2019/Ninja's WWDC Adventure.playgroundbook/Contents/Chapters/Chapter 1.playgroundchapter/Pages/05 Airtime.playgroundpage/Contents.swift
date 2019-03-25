//#-hidden-code
import PlaygroundSupport

var passed = true

enum Direction {
    
    case left
    case right
    
}

//#-end-hidden-code
/*:
 # ☁ Airtime
 Fantastic! Ninja has regained his ability to move left and right. Now, we need to help him re-learn how to jump!
 
 We'll use a [function](glossary://Function) to accomplish this.
 
 ## Goal
 * callout(Goal:):
 1. When the joystick is moved up, use the ```jump``` function.
 
 When you're ready to test your code, go ahead and press "Run my code".
*/

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, jump())

func didMoveJoystickUp() {
    // Jump!
    //#-editable-code
    <#jump()#>
    //#-end-editable-code
}

//#-hidden-code

func jump() {
    passed = true
}

passed = false
didMoveJoystickUp()

if passed {
    PlaygroundBridge.send(.jumping)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Fantastic! \n\n It looks like Ninja can jump again, next up, let's learn how we can help him collect his ticket pieces. \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "Type ```jump()``` inside of ```didMoveJoystickUp```.")
}

//#-end-hidden-code
