//#-hidden-code
import PlaygroundSupport

var passed = true

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, ., epic, funky, crazy)

enum Music: String {

    case funky = "Funky.mp3"
    case crazy = "Crazy.mp3"
    case epic = "Epic.mp3"
    
}

var backgroundMusic: Music = .funky {
    didSet {
        passed = true
        PlaygroundBridge.send(.backgroundMusic, data: backgroundMusic.rawValue)
        
        PlaygroundKeyValueStore.current["backgroundMusic"] = .string(backgroundMusic.rawValue)
    }
}
//#-end-hidden-code
/*:
 # 🎧 Let's Get Loud
 We've given Ninja the ability to walk, jump, and find his ticket pieces. He can attend WWDC19 now!
 
 Let's make his journey a bit more... epic! Let's change the background music.
 
 To do this, we need to learn about [variables](glossary://Variable). A variable stores information of a certain type. In this case, we have a variable called ```backgroundMusic```. ```backgroundMusic``` is a ```Music``` variable.
 
 Ninja has made three different tracks that he'd like to listen to. These tracks are represented by ```Music``` variables, which have three possible values: ```.funky```, ```.crazy```, and ```.epic```.
 
 You can change a variable's value by typing the name of the variable, followed by a space, and then the value you would like it to be:
 
 ```
 backgroundMusic = .funky
 ```
 
 ## Goal
 * callout(Goal:):
 1. Change the value of backgroundMusic to be either ```.funky```, ```.crazy```, or ```.epic```.
 
 When you're ready to test your code, press "Run my code".
*/

backgroundMusic = /*#-editable-code*/<#.epic#>/*#-end-editable-code*/

//#-hidden-code

if passed {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# \(backgroundMusic.rawValue.split(separator: ".")[0])! \n\n I'm sure Ninja will appriciate your \(backgroundMusic.rawValue.split(separator: ".")[0].lowercased()) tunes. \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "Type ```.funky```, ```.epic```, or ```.crazy```.")
}

//#-end-hidden-code
