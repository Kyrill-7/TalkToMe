import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()
    private let analyzer = PsychometricAnalyzer()
    
    @State private var isRecording = false
    @State private var results: PsychometricResult?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Talk to Me")
                .font(.largeTitle)
                .bold()
            
            ScrollView {
                Text(recognizer.transcript.isEmpty ? "Say something..." : recognizer.transcript)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .frame(height: 200)
            
            Button(action: {
                if isRecording {
                    recognizer.stopTranscribing()
                    isRecording = false
                    
                    // ✅ Analyze transcript when done
                    results = analyzer.analyze(text: recognizer.transcript)
                    
                } else {
                    recognizer.requestAuthorization()
                    recognizer.startTranscribing()
                    isRecording = true
                    results = nil
                }
            }) {
                Text(isRecording ? "Stop & Analyze" : "Start Talking")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            if let results = results {
                VStack {
                    Text("Psychometric Analysis")
                        .font(.headline)
                    
                    Chart {
                        BarMark(x: .value("Metric", "Positivity"), y: .value("Score", results.positivity))
                        BarMark(x: .value("Metric", "Negativity"), y: .value("Score", results.negativity))
                        BarMark(x: .value("Metric", "Stress"), y: .value("Score", results.stress))
                        BarMark(x: .value("Metric", "Confidence"), y: .value("Score", results.confidence))
                    }
                    .frame(height: 200)
                }
                .padding()
            }
            
            Spacer()
        }
    }
}
