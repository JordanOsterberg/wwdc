//#-hidden-code
import PlaygroundSupport

var ticketsAdded = false
var ticketsCollected = false

func addTickets() {
    ticketsAdded = true
    PlaygroundBridge.send(.addTickets)
}

func collectTicketPiece() {
    ticketsCollected = true
    PlaygroundBridge.send(.allowTicketPickup)
}

//#-end-hidden-code
/*:
 # 🎟 Ticketing
 Ninja is able to move now, but where are those ticket pieces? Oh no! 🙊 It looks like they're not in the scene yet.
 
 Let's use two [functions](glossary://Function) to add them in and allow Ninja to collect them.
 
 First, add the tickets to the scene with the ```addTickets``` function.

 Secondly, inside of the ```ninjaFoundTicket``` function, use the ```collectTicket``` function. ```ninjaFoundTicket``` is run whenever Ninja runs into a ticket.
 
 ## Goal
 * callout(Goal:):
 1. Add the tickets to the scene by using the ```addTickets``` function.
 2. Inside of the ```ninjaFoundTicketPiece``` function, use the ```collectTicketPiece``` function.
 
 When you're ready to test your code, press "Run my code".
*/

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, addTickets(), collectTicketPiece())

//#-editable-code

//#-end-editable-code

func ninjaFoundTicketPiece() {
    // Collect the ticket piece!
    //#-editable-code
    
    //#-end-editable-code
}

//#-hidden-code

ninjaFoundTicketPiece()

if ticketsAdded && ticketsCollected {
    PlaygroundPage.current.assessmentStatus = .pass(message: "# Admitted! \n\n Ninja can now make it into WWDC19! Let's make his journey a bit more pleasant... \n\n[Next Page](@next)")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Make sure to use ```addTickets()```, and inside of ```ninjaFoundTicketPiece```, use ```collectTicketPiece()```."], solution: "Type ```addTickets()```, and inside of ```ninjaFoundTicketPiece```, type ```collectTicketPiece()```.")
}

//#-end-hidden-code
