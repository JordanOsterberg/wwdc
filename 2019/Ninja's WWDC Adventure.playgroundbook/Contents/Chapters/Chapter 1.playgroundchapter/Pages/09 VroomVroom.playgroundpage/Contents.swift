//#-hidden-code
import PlaygroundSupport

var addedCars = false

func addCars() {
    addedCars = true
    PlaygroundBridge.send(.addCars)
}

var changedDuration = false

var duration = 4 {
    didSet {
        if duration < 1 {
            duration = 1
        }
        
        changedDuration = true
        
        PlaygroundBridge.send(.carDuration, data: String(duration))
        PlaygroundKeyValueStore.current["carDuration"] = .floatingPoint(Double(duration))
    }
}

//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, duration, =, 1, 2, 3, 4, addCars())
/*:
 # 🚙 Vroom Vroom
 Let's add some traffic into our city! Firstly, you'll use the ```addCars``` function to add the cars into our scene.
 
 💡 **Tip**: Find a road to watch the cars vroom by.
 
 Next, you'll change the speed of the cars by changing the ```duration``` of their travel. The ```duration``` is a variable with a value of ```4``` by default. The lower, the faster the cars. The higher, the slower.
 
 ## Goal
 * callout(Goal:):
 1. Use the ```addCars``` function to add the cars into the scene.
 2. Change the ```duration``` of the cars' travel.
 
 When you're ready to test your code, press "Run my code".
*/
// Add the cars to the scene and change the duration
//#-editable-code

//#-end-editable-code

//#-hidden-code
if addedCars && changedDuration {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Zooming! \n\n I bet you Ninja loves having some passerbys to admire him. Now, let's talk dogs (and booleans!)...\n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Use both ```addCars()``` and change the value of ```duration```"], solution: "Type ```addCars()``` and ```duration = 2```")
}

//#-end-hidden-code
