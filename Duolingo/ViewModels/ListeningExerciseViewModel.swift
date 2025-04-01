// ViewModels/ListeningExerciseViewModel.swift
import Combine
import SwiftUI
import AVFoundation

class ListeningExerciseViewModel: ObservableObject {
    @Published var currentExercise: Exercise?
    @Published var userInput: String = ""
    @Published var selectedWords: [String] = [] // Added for word pill selection
    @Published var isAnswered = false
    @Published var isCorrect = false
    @Published var isPlaying = false
    @Published var isPlayingSlow = false
    @Published var playbackProgress: Double = 0.0
    @Published var streakCount: Int = 0
    @Published var heartsCount: Int = 5
    @Published var progressValue: CGFloat = 0.0
    @Published var lesson: Lesson
    
    private var audioPlayer: AVAudioPlayer?
    private var progressTimer: Timer?
    private var normalRate: Float = 1.0
    private var slowRate: Float = 0.5
    
    init(lesson: Lesson, exerciseIndex: Int) {
        self.lesson = lesson
        loadExercise(at: exerciseIndex)
    }
    
    func loadExercise(at index: Int) {
        guard index < lesson.exercises.count else {
            print("Exercise index out of bounds")
            return
        }
        
        let exercise = lesson.exercises[index]
        guard exercise.type == .listening else {
            print("Incorrect exercise type for DuolingoListeningView")
            return
        }
        self.currentExercise = exercise
        setupAudio()
    }
    
    func checkAnswer() {
        guard let exercise = currentExercise else { return }
        isAnswered = true
        
        if !selectedWords.isEmpty {
            // Check answer using selected words
            if let correctAnswers = exercise.correctAnswer {
                // Check if sequence and content of selected words matches any correct answer
                let selectedAnswer = selectedWords.joined(separator: " ").lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                let isMatch = correctAnswers.contains { 
                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == selectedAnswer
                }
                
                isCorrect = isMatch
                
                if isCorrect {
                    streakCount += 1
                    progressValue = min(1.0, progressValue + 0.1)
                } else {
                    streakCount = 0
                    heartsCount = max(0, heartsCount - 1)
                }
            }
        } else {
            // Fallback to text input checking for backward compatibility
            // Convert to lowercase for case-insensitive comparison
            let userAnswerLower = userInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Check if the user's answer matches any of the correct answers (case insensitive)
            if let correctAnswers = exercise.correctAnswer {
                let isMatch = correctAnswers.contains { 
                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == userAnswerLower
                }
                
                isCorrect = isMatch
                
                if isCorrect {
                    streakCount += 1
                    progressValue = min(1.0, progressValue + 0.1)
                } else {
                    streakCount = 0
                    heartsCount = max(0, heartsCount - 1)
                }
            }
        }
    }
    
    func resetExercise() {
        isAnswered = false
        isCorrect = false
        userInput = ""
        selectedWords = [] // Clear selected words
        stopAudio()
    }
    
    func playAudio(slow: Bool = false) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                isPlaying = false
                isPlayingSlow = false
                stopProgressTimer()
            } else {
                // Set playback rate based on slow parameter
                player.rate = slow ? slowRate : normalRate
                player.play()
                isPlaying = true
                isPlayingSlow = slow
                startProgressTimer()
            }
        } else {
            setupAudio()
            playAudio(slow: slow)
        }
    }
    
    private func setupAudio() {
        guard let exercise = currentExercise, let audioURLString = exercise.audioURL else {
            print("No audio URL provided for exercise")
            return
        }
        
        // In a real app, this would load from actual audio files
        // For demonstration, we'll use a mock approach
        if audioURLString == "mock" {
            // Simulate playback without actual audio
            print("Setting up mock audio")
            return
        }
        
        // For real implementation, load from Bundle or remote URL
        if let url = Bundle.main.url(forResource: audioURLString, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio: \(error)")
            }
        } else {
            print("Audio file not found: \(audioURLString)")
        }
    }
    
    private func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.playbackProgress = player.currentTime / player.duration
            
            if player.currentTime >= player.duration {
                self.isPlaying = false
                self.playbackProgress = 0
                self.stopProgressTimer()
            }
        }
    }
    
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        playbackProgress = 0
        stopProgressTimer()
    }
    
    deinit {
        stopAudio()
    }
}