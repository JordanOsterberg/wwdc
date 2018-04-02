//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit

class Cat {
    
    var completionHandler : ((_ direction: Direction) -> Void)!
    
    //#-code-completion(identifier, show, moveLeft())
    //#-code-completion(identifier, show, moveRight())
    func moveLeft() {
        completionHandler(.left)
    }
    
    func moveRight() {
        completionHandler(.right)
    }
    
}

enum Direction {
    
    case left
    case right
    
}

var leftCompleted = false
var rightCompleted = false

let cat = Cat()
cat.completionHandler = { direction in
    if direction == .left {
        leftCompleted = true
    } else {
        rightCompleted = true
    }
}
//#-end-hidden-code
/*:
 # Get Moving!
 
 We can see our cat, but he can't move. Let's change that! To allow our cat to move, we need to use more [functions](glossary://Function).
 
 Let's program the left and right buttons to move the cat.
 
 In this case, we have an object called `cat` that has two functions that are used to move it: `moveLeft` and `moveRight`
 
 To call functions that are part of objects, type the name of the object, `cat`, followed by a period, then type the name of the function, `moveLeft` or `moveRight`. The final product of this function call looks like this: `cat.moveLeft()` or `cat.moveRight()`
 
 * callout(Goal:):
 Use `cat.moveLeft()` to move left, and `cat.moveRight()` to move right. Easy, right? (Pun intended)
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, cat, .)
func leftButtonTapped() {
    // Move the cat left
    //#-editable-code
    
    //#-end-editable-code
}

func rightButtonTapped() {
    // Move the cat right
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code

func check() -> Bool {
    leftButtonTapped()
    if !leftCompleted {
        return false
    }
    
    rightButtonTapped()
    if !rightCompleted {
        return false
    }
    
    return true
}

if check() {
    PlaygroundPageBridge.send(value: .allowMovement)
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Excellent! \n\n Our cat can move left and right now. But he's missing something...\n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Not quite... Make sure you spell and capitalize everything correctly and you allow the cat to move both left and right.", "Make sure you move the cat in the correct direction."], solution: "Inside of the `leftTapped` function:\n\n`cat.moveLeft()`\n\nInside of the `rightTapped` function:\n\n`cat.moveRight()`")
}
//#-end-hidden-code
