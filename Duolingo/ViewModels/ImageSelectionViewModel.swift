// ViewModels/ImageSelectionViewModel.swift
import Combine
import SwiftUI

class ImageSelectionViewModel: ObservableObject {
    @Published var currentExercise: Exercise?
    @Published var selectedImageId: UUID?
    @Published var isAnswered = false
    @Published var isCorrect = false
    @Published var streakCount: Int = 0
    @Published var heartsCount: Int = 5
    @Published var progressValue: CGFloat = 0.0
    @Published var lesson: Lesson

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
        guard exercise.type == .imageSelection else {
            print("Incorrect exercise type for ImageSelectionView")
            return
        }
        self.currentExercise = exercise
        resetExercise()
    }

    func checkAnswer() {
        guard let exercise = currentExercise,
              let selectedId = selectedImageId,
              let selectedOption = exercise.imageOptions?.first(where: { $0.id == selectedId }) else {
            return
        }

        isAnswered = true
        if selectedOption.isCorrect {
            isCorrect = true
            streakCount += 1
            progressValue = min(1.0, progressValue + 0.1)
        } else {
            isCorrect = false
            streakCount = 0
            heartsCount = max(0, heartsCount - 1)
        }
    }

    func resetExercise() {
        isAnswered = false
        isCorrect = false
        selectedImageId = nil
    }
}