import Foundation

class SimpleBot {
    func reply(to userText: String) -> String {
        let lowerText = userText.lowercased()
        
        if lowerText.contains("sad") || lowerText.contains("depressed") {
            return "I'm here for you. Want to tell me more about it?"
        } else if lowerText.contains("happy") {
            return "That's awesome! What made you feel so good?"
        } else if lowerText.contains("lonely") {
            return "You’re not alone anymore. I’m here to talk."
        } else {
            return "Hmm, tell me more..."
        }
    }
}
