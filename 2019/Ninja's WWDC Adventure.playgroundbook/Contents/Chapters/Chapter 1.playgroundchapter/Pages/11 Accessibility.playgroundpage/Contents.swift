//#-hidden-code
import PlaygroundSupport

var passed = false

func speakTextVoiceOver(_ text: String) {
    passed = true
    PlaygroundBridge.send(.voiceOverBanner, data: text)
}

//#-end-hidden-code
/*:
 # ♿️ Accessibility
 Our game is good, but we need to make it stand out from the rest. Accessibility is a great way to do that!
 
 By making our game accessible, we open it up to everybody, which gives everyone the chance to help Ninja get to WWDC19.
 
 So... how do we even start? A great place to start with Accessibility is **VoiceOver**! VoiceOver is a "screen reader" technology created by Apple. It reads different elements on the screen aloud to visually impaired users.
 
 Within games, something we can do is describe the background behind the player (Ninja, in our case), and have VoiceOver speak it aloud.
 
 To do this final step in creating our game, we need to expand our knowledge of [functions](glossary://Function).
 
 Functions can have parameters, or inputs, whenever we use them. For example, we have a function called ```speakTextVoiceOver```. Normally to call a function, you type the name of the function, followed by two parenthesis. Whenever a function has parameters, inside of the parenthesis you type the value of that parameter.
 
 Let's look at an example:
 
 ```
 func ninjaPassedAppleStore() {
    // Notice that inside of the parenthesis, we insert a piece of text. Whenever we type text in Swift, we use quotation marks to signal the start and end of our text.
    speakTextVoiceOver("Ninja is in front of the Apple Store.")
 }
 ```
 
 Now you try it!
 
 💡 **Tip**: Bring Ninja to the WWDC banner on the far right of the level. If you don't have VoiceOver enabled, you'll see whatever you type appear above the banner.
 
 ## Goal
 * callout(Goal:):
 1. Inside of the ```ninjaPassedNeonWWDCBanner``` function, use the ```speakTextVoiceOver``` function to read a description of the Neon WWDC Banner to VoiceOver users.
*/

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, passed, ninjaPassedNeonWWDCBanner())
func ninjaPassedNeonWWDCBanner() {
    // Use the speakTextVoiceOver function to read a description of the Neon WWDC Banner to VoiceOver users.
    // Make sure to type your text within quotation marks, or you won't be able to run your code!
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code

passed = false
ninjaPassedNeonWWDCBanner()

if passed {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Awesome Accessiblility! \n\n I'm sure Ninja will appricate the extra attention from the new users who can use our game!!\n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: [], solution: "Type ```speakTextVoiceOver(\"Ninja is in front of the Neon WWDC Banner.\")``` inside of ```ninjaPassedNeonWWDCBanner```.")
}

//#-end-hidden-code
