import Foundation

struct PsychometricResult {
    let positivity: Double
    let negativity: Double
    let stress: Double
    let confidence: Double
}

class PsychometricAnalyzer {
    private let positiveWords: [String: Double] = [
        "happy": 1.0, "joy": 1.2, "love": 1.3, "great": 1.1,
        "awesome": 1.5, "good": 0.8, "excited": 1.2, "fantastic": 1.6, "wonderful": 1.4
    ]
    
    private let negativeWords: [String: Double] = [
        "sad": 1.0, "bad": 0.9, "angry": 1.2, "upset": 1.1,
        "tired": 0.8, "lonely": 1.2, "depressed": 1.5, "terrible": 1.4, "awful": 1.3
    ]
    
    private let stressWords: [String: Double] = [
        "stress": 1.2, "anxious": 1.3, "worried": 1.1,
        "overwhelmed": 1.4, "panic": 1.5, "nervous": 1.2
    ]
    
    private let confidentWords: [String: Double] = [
        "confident": 1.2, "sure": 1.0, "certain": 1.1,
        "strong": 1.2, "capable": 1.3, "fearless": 1.5, "determined": 1.4
    ]
    
    func analyze(text: String) -> PsychometricResult {
        let words = text
            .lowercased()
            .split { !$0.isLetter }  // split on spaces & punctuation
            .map { String($0) }
        
        var positive = 0.0
        var negative = 0.0
        var stress = 0.0
        var confidence = 0.0
        
        for word in words {
            if let score = positiveWords[word] { positive += score }
            if let score = negativeWords[word] { negative += score }
            if let score = stressWords[word] { stress += score }
            if let score = confidentWords[word] { confidence += score }
        }
        
        let total = max(1.0, Double(words.count)) // normalize by all words in transcript
        
        return PsychometricResult(
            positivity: positive / total,
            negativity: negative / total,
            stress: stress / total,
            confidence: confidence / total
        )
    }
}
