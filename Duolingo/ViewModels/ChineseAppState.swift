//
//  ChineseAppState.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// ViewModels/ChineseAppState.swift
import SwiftUI
import Combine

class ChineseAppState: ObservableObject {
    @Published var availableCourses: [Course] = []
    @Published var userProgress: UserProgress = UserProgress(currentStreak: 0, wordsLearned: 0, xpPoints: 0, completedLessons: [])
    @Published var currentLesson: Lesson? = nil
    @Published var currentExerciseIndex: Int = 0
    @Published var isInExerciseView: Bool = false  // Add this property

    // Load data on app launch.
    init() {
        loadCourses()
        loadProgress()
    }

    // MARK: - Data Loading and Saving

    func loadCourses() {
        // Load from the main bundle first.
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json") else {
            print("courses.json not found in main bundle")
            return
        }
        print("Found courses.json at: \(url)")

        do {
            let data = try Data(contentsOf: url)
            availableCourses = try JSONDecoder().decode([Course].self, from: data)
            print("Successfully loaded \(availableCourses.count) courses")
        } catch {
            print("Error loading courses: \(error)")
        }
    }


    func loadProgress() {
        // Use if let to safely unwrap the optional data.
        if let data = UserDefaults.standard.data(forKey: "userProgress"),
           let decodedProgress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            userProgress = decodedProgress
        }
    }

    func saveProgress() {
        // Use if let to safely wrap the encoded data.
        if let encodedProgress = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(encodedProgress, forKey: "userProgress")
        }
    }

    // MARK: - Lesson and Exercise Navigation

    func startLesson(_ lesson: Lesson) {
        currentExerciseIndex = 0
        currentLesson = lesson
    }

    // Handles completing an exercise and updating user progress.
    func completeCurrentExercise() {
        guard let currentLesson = currentLesson else { return }

        if currentExerciseIndex < currentLesson.exercises.count - 1 {
            // Move to the next exercise.
            currentExerciseIndex += 1
        } else {
            // Lesson completed.
            completeLesson(currentLesson)
        }
    }

    private func completeLesson(_ lesson: Lesson) {
        if !userProgress.completedLessons.contains(lesson.id) {
            userProgress.completedLessons.append(lesson.id)
            updateProgress(xpGained: 10, wordsLearned: 5)  // Use a method for better organization
            saveProgress() // Save after any progress change.
        }
        currentLesson = nil
        currentExerciseIndex = 0
    }

    // Separate method for updating various progress metrics keeps things organized.
    private func updateProgress(xpGained: Int, wordsLearned: Int) {
        userProgress.xpPoints += xpGained
        userProgress.dailyXPEarned += xpGained
        userProgress.currentStreak += 1  //  increment this on *any* lesson completion (not just daily)
        userProgress.wordsLearned += wordsLearned

        // Check if it's a new day for daily goals.
        if !Calendar.current.isDate(userProgress.lastLoginDate, inSameDayAs: Date()) {
            userProgress.dailyXPEarned = xpGained // Reset and count current XP, as a new day starts
            userProgress.lastLoginDate = Date()
        }
    }
}