//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

var passed = false

class Cat {
    
    var completionHandler : (() -> Void)!
    
    //#-code-completion(identifier, show, jump())
    func jump() {
        completionHandler()
    }
    
}

let cat = Cat()
cat.completionHandler = {
    PlaygroundPageBridge.send(value: .allowJumping)
    passed = true
}
//#-end-hidden-code
/*:
 # Jump Around
 
 Our cat can move, but he can't jump. We can use another simple [function](glossary://Function) to allow him to jump!
 
 * callout(Goal:):
 Use `cat.jump()` to make him jump!
 
 Try it out! When the function `jumpTapped` is called, make him jump.
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, cat, .)
func jumpTapped() {
    // Make the cat jump!
    //#-editable-code
    
    //#-end-editable-code
}
//#-hidden-code

jumpTapped()

if passed {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Exquisite! \n\n Our cat can now freely move about the cabin. Use the jump buttons to make him jump! \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you spell and capitalize everything correctly."], solution: "Inside of `jumpTapped`, call the `cat.jump()` function.")
}
//#-end-hidden-code
