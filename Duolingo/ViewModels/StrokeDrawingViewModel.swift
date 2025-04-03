//
//  StrokeDrawingViewModel.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI
import Combine

class StrokeDrawingViewModel: ObservableObject {
    @Published var currentExercise: Exercise?
    @Published var currentCharacterIndex: Int = 0
    @Published var currentStrokeIndex: Int = 0
    @Published var isShowingAnimation: Bool = false
    @Published var userStrokes: [[CGPoint]] = []
    @Published var currentUserStroke: [CGPoint] = []
    @Published var isAnswered: Bool = false
    @Published var isCorrect: Bool = false
    @Published var showStrokeHint: Bool = false
    @Published var streakCount: Int = 0
    @Published var heartsCount: Int = 5
    @Published var progressValue: CGFloat = 0.0
    @Published var showFeedback: Bool = false
    @Published var feedbackMessage: String = ""
    @Published var lesson: Lesson
    
    private var minimumPointsForStroke = 5
    private var strokeSimilarityThreshold = 0.7 // 0.0 to 1.0, where 1.0 is perfect match
    
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
        guard exercise.type == .strokeDrawing else {
            print("Incorrect exercise type for StrokeDrawingView")
            return
        }
        
        self.currentExercise = exercise
        resetExercise()
    }
    
    func resetExercise() {
        currentCharacterIndex = 0
        currentStrokeIndex = 0
        userStrokes = []
        currentUserStroke = []
        isAnswered = false
        isCorrect = false
        showStrokeHint = false
        showFeedback = false
    }
    
    var currentCharacter: StrokeCharacter? {
        guard let strokeCharacters = currentExercise?.strokeCharacters,
              currentCharacterIndex < strokeCharacters.count else {
            return nil
        }
        return strokeCharacters[currentCharacterIndex]
    }
    
    var currentStrokePath: StrokePath? {
        guard let character = currentCharacter,
              currentStrokeIndex < character.strokeOrder.count else {
            return nil
        }
        return character.strokeOrder[currentStrokeIndex]
    }
    
    var completedStrokePaths: [StrokePath] {
        guard let character = currentCharacter else { return [] }
        return Array(character.strokeOrder[0..<min(currentStrokeIndex, character.strokeOrder.count)])
    }
    
    var remainingStrokePaths: [StrokePath] {
        guard let character = currentCharacter else { return [] }
        if currentStrokeIndex >= character.strokeOrder.count {
            return []
        }
        return Array(character.strokeOrder[currentStrokeIndex..<character.strokeOrder.count])
    }
    
    func startStrokeDrawing(at point: CGPoint) {
        if isAnswered { return }
        currentUserStroke = [point]
    }
    
    func continueStrokeDrawing(to point: CGPoint) {
        if isAnswered { return }
        currentUserStroke.append(point)
    }
    
    func endStrokeDrawing() {
        guard !isAnswered, currentUserStroke.count >= minimumPointsForStroke else {
            currentUserStroke = []
            return
        }
        
        // Add completed stroke to user strokes collection
        userStrokes.append(currentUserStroke)
        
        // Validate the stroke against the expected stroke
        validateCurrentStroke()
        
        // Clear current stroke
        currentUserStroke = []
    }
    
    func validateCurrentStroke() {
        guard let currentStroke = currentStrokePath else { return }
        
        let lastUserStroke = userStrokes.last ?? []
        let similarity = calculateStrokeSimilarity(userStroke: lastUserStroke, targetStroke: currentStroke.points)
        
        if similarity >= strokeSimilarityThreshold {
            // Stroke is correct
            showFeedback(message: "Good job!", isPositive: true)
            
            // Move to next stroke
            currentStrokeIndex += 1
            
            // Check if we completed all strokes for this character
            if let character = currentCharacter, currentStrokeIndex >= character.strokeOrder.count {
                handleCharacterCompletion()
            }
        } else {
            // Stroke is incorrect
            showFeedback(message: "Try again", isPositive: false)
            
            // Remove the incorrect stroke from userStrokes
            if !userStrokes.isEmpty {
                userStrokes.removeLast()
            }
            
            // Decrement hearts
            heartsCount = max(0, heartsCount - 1)
            
            // Show hint after a failed attempt
            showStrokeHint = true
            
            // Auto-hide hint after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                withAnimation {
                    self?.showStrokeHint = false
                }
            }
        }
    }
    
    func handleCharacterCompletion() {
        isAnswered = true
        isCorrect = true
        streakCount += 1
        progressValue = min(1.0, progressValue + 0.1)
        
        showFeedback(message: "Character complete!", isPositive: true)
        
        // Move to next character (if available) or complete exercise
        if let strokeCharacters = currentExercise?.strokeCharacters,
           currentCharacterIndex < strokeCharacters.count - 1 {
            // More characters to practice
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.currentCharacterIndex += 1
                self?.currentStrokeIndex = 0
                self?.userStrokes = []
                self?.isAnswered = false
                self?.showFeedback = false
            }
        } else {
            // Exercise complete
            isCorrect = true
        }
    }
    
    private func showFeedback(message: String, isPositive: Bool) {
        feedbackMessage = message
        showFeedback = true
        
        // Auto-hide feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation {
                self?.showFeedback = false
            }
        }
    }
    
    func playStrokeAnimation() {
        if isShowingAnimation { return }
        isShowingAnimation = true
        
        // Auto-hide animation after a delay based on character's animation speed
        let animationDuration = currentCharacter?.animationSpeed ?? 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.isShowingAnimation = false
        }
    }
    
    // Simplified stroke similarity calculation
    // In a real app, this would use a more sophisticated algorithm for stroke recognition
    private func calculateStrokeSimilarity(userStroke: [CGPoint], targetStroke: [CGPoint]) -> Double {
        guard !userStroke.isEmpty, !targetStroke.isEmpty else { return 0.0 }
        
        // For our mock implementation, we'll use a simple check based on:
        // 1. Direction similarity
        // 2. Start and end point proximity
        
        // Check start and end points
        let userStart = userStroke.first!
        let userEnd = userStroke.last!
        let targetStart = targetStroke.first!
        let targetEnd = targetStroke.last!
        
        // Calculate distances
        let startDistance = distance(userStart, targetStart)
        let endDistance = distance(userEnd, targetEnd)
        
        // Normalize distances based on the canvas size (assuming 300x300 canvas)
        let canvasSize: CGFloat = 300
        let normalizedStartDistance = 1.0 - min(1.0, startDistance / (canvasSize * 0.3))
        let normalizedEndDistance = 1.0 - min(1.0, endDistance / (canvasSize * 0.3))
        
        // Check overall direction
        let userDirection = direction(from: userStart, to: userEnd)
        let targetDirection = direction(from: targetStart, to: targetEnd)
        let directionSimilarity = 1.0 - min(1.0, abs(userDirection - targetDirection) / CGFloat.pi)
        
        // Compute overall similarity (equal weights for now)
        let similarity = (normalizedStartDistance + normalizedEndDistance + directionSimilarity) / 3.0
        
        return similarity
    }
    
    private func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    private func direction(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return atan2(p2.y - p1.y, p2.x - p1.x)
    }
}