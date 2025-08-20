import Foundation

struct PsychometricResult {
    let positivity: Double
    let negativity: Double
    let stress: Double
    let confidence: Double
}

class PsychometricAnalyzer {
    private let positiveWords = ["happy", "joy", "love", "great", "awesome", "good", "excited"]
    private let negativeWords = ["sad", "bad", "angry", "upset", "tired", "lonely", "depressed"]
    private let stressWords = ["stress", "anxious", "worried", "overwhelmed"]
    private let confidentWords = ["confident", "sure", "certain", "strong", "capable"]
    
    func analyze(text: String) -> PsychometricResult {
        let words = text.lowercased().split(separator: " ").map { String($0) }
        
        let positive = Double(words.filter { positiveWords.contains($0) }.count)
        let negative = Double(words.filter { negativeWords.contains($0) }.count)
        let stress = Double(words.filter { stressWords.contains($0) }.count)
        let confidence = Double(words.filter { confidentWords.contains($0) }.count)
        
        let total = max(1.0, positive + negative + stress + confidence)
        
        return PsychometricResult(
            positivity: positive / total,
            negativity: negative / total,
            stress: stress / total,
            confidence: confidence / total
        )
    }
}
