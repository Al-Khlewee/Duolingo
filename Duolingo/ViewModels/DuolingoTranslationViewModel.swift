//
//  DuolingoTranslationViewModel.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// ViewModels/DuolingoTranslationViewModel.swift
import Combine
import SwiftUI

class DuolingoTranslationViewModel: ObservableObject {
    @Published var currentExercise: Exercise? // Holds the current exercise.
    @Published var selectedWords: [String] = []
    @Published var isAnswered = false
    @Published var isCorrect = false
    @Published var isPlaying = false //  track audio playback
    @Published var lesson: Lesson

    @Published var streakCount: Int = 0
    @Published var heartsCount: Int = 5
    @Published var progressValue: CGFloat = 0.0


    init(lesson: Lesson, exerciseIndex: Int) {
        self.lesson = lesson
        loadExercise(at: exerciseIndex)
    }


    func loadExercise(at index: Int) {
        // Check if the index is within the valid range.
        guard index < lesson.exercises.count else {
            print("Exercise index out of bounds")
            return
        }

        let exercise = lesson.exercises[index]
        // Ensure the exercise is of the correct type.
        guard exercise.type == .translation else {
            print("Incorrect exercise type for DuolingoTranslationView")
            return
        }
        self.currentExercise = exercise
    }

    //  check the user's answer.
    func checkAnswer() {
        guard let exercise = currentExercise else { return }
        isAnswered = true
        if selectedWords == exercise.correctAnswer {
            isCorrect = true
            streakCount += 1
            progressValue = min(1.0, progressValue + 0.1) // Increment by a fixed amount.
        } else {
            isCorrect = false
            streakCount = 0  // Reset streak on incorrect answer.
            heartsCount = max(0, heartsCount - 1) // Decrement hearts.
        }
    }

    //  reset the exercise state for retries.
    func resetExercise() {
        isAnswered = false
        isCorrect = false
        selectedWords = []
        //Shuffle available words
        if var ex = currentExercise {
            ex.availableWords?.shuffle()
            currentExercise = ex
        }
    }

    // Plays audio for the exercise.
    func playAudio() {
        // Implement audio playback logic here.
        isPlaying = true
        // Simulate audio playback with a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isPlaying = false
        }
    }
}