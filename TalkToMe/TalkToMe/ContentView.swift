import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()
    private let analyzer = PsychometricAnalyzer()
    
    @State private var isRecording = false
    @State private var results: PsychometricResult?
    @State private var navigateToResults = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("🎤 Talk to Me")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 50)
                    
                    ScrollView {
                        Text(recognizer.transcript.isEmpty ? "Say something..." : recognizer.transcript)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .shadow(radius: 3)
                            .padding(.horizontal)
                    }
                    .frame(height: 200)
                    
                    Button(action: {
                        if isRecording {
                            recognizer.stopTranscribing()
                            isRecording = false
                            
                            // Analyze and go to next screen
                            results = analyzer.analyze(text: recognizer.transcript)
                            navigateToResults = true
                            
                        } else {
                            recognizer.requestAuthorization()
                            recognizer.startTranscribing()
                            isRecording = true
                            results = nil
                        }
                    }) {
                        Text(isRecording ? "⏹ Stop & Analyze" : "🎙 Start Talking")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isRecording ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(radius: 4)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToResults) {
                if let results = results {
                    ResultsView(results: results, transcript: recognizer.transcript)
                }
            }
        }
    }
}

// MARK: - Results Screen
struct ResultsView: View {
    var results: PsychometricResult
    var transcript: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.purple.opacity(0.1), Color.orange.opacity(0.1)],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("📊 Your Analysis")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Transcript:")
                        .font(.headline)
                    Text(transcript)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                    
                    Chart {
                        BarMark(
                            x: .value("Metric", "Positivity"),
                            y: .value("Score", results.positivity * 100)
                        )
                        .foregroundStyle(Color.green.gradient)
                        
                        BarMark(
                            x: .value("Metric", "Negativity"),
                            y: .value("Score", results.negativity * 100)
                        )
                        .foregroundStyle(Color.red.gradient)
                        
                        BarMark(
                            x: .value("Metric", "Stress"),
                            y: .value("Score", results.stress * 100)
                        )
                        .foregroundStyle(Color.orange.gradient)
                        
                        BarMark(
                            x: .value("Metric", "Confidence"),
                            y: .value("Score", results.confidence * 100)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                    .frame(height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}
