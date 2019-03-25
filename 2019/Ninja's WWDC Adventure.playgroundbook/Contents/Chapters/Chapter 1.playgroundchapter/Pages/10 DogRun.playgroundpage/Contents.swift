//#-hidden-code
import PlaygroundSupport

var hasForesterBeenFed = false
var addedCarrot = false

func addCarrot() {
    addedCarrot = true
    
    PlaygroundBridge.send(.addCarrot)
}

//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addCarrot(), hasForesterBeenFed, =, true)
/*:
 # 🐶 Dog, run!
 Every good game about awesome cats usually contains a good dog! While Forester the Dog may seem fearsome, he's actually a good friend of Ninja. Why don't we feed Forester?
 
 💡 **Tip**: Forester is past the Apple Store, in the small grove of trees. The carrot to feed him is located to the far right of the city, just before the conference center.
 
 Forester, as good of a boy as he is, cannot be fed more than once per game. In order to track if he has been fed or not, we can use a [boolean](glossary://Boolean)!
 
 A boolean is a type of variable that is either ```true``` or ```false```.
 
 Inside of the function ```ninjaGaveForesterCarrot```, change the ```hasForesterBeenFed``` boolean to ```true```.
 
 Before changing ```ninjaGaveForesterCarrot```, make sure to add the carrot to the scene by using the ```addCarrot``` function.
 
 ## Goal
 * callout(Goal:):
 1. Add the carrot to the scene by using the ```addCarrot``` function.
 2. Inside of ```ninjaGaveForesterCarrot```, change ```hasForesterBeenFed``` to ```true```.
 
 When you're ready to test your code, press "Run my code".
*/
// Add the carrot to the scene
//#-editable-code

//#-end-editable-code

func ninjaGaveForesterCarrot() {
    // Change hasForesterBeenFed to true
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code

hasForesterBeenFed = false // Prevent issues
ninjaGaveForesterCarrot()

if hasForesterBeenFed && addedCarrot {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Delicious! \n\n I bet you Forester enjoyed that carrot. There's just one more thing left to do...\n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Make sure to use both ```addCarrot()``` and set ```hasForesterBeenFed``` to true."], solution: "Type ```addCarrot()```, and inside of ```foresterWasFed```, type ```hasForesterBeenFed = true```.")
}

//#-end-hidden-code
