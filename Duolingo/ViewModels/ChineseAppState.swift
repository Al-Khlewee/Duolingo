//
//  ChineseAppState.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI
import Combine

class ChineseAppState: ObservableObject {
    // MARK: - Published Properties
    @Published var availableCourses: [Course] = []
    @Published var userProgress: UserProgress = UserProgress(
        currentStreak: 3,
        wordsLearned: 82, 
        xpPoints: 450,
        completedLessons: []
    )
    @Published var currentLesson: Lesson? = nil
    @Published var currentExerciseIndex: Int = 0
    @Published var isInExerciseView: Bool = false
    
    // Color scheme preference
    @AppStorage("userColorScheme") var userColorScheme: String = "auto"
    
    // MARK: - Initialization
    init() {
        loadCourses()
        loadProgress()
    }
    
    // MARK: - Theme Management
    // Computed property to get the appropriate ColorScheme based on user preference
    var colorScheme: ColorScheme? {
        switch userColorScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil // "auto" - use system setting
        }
    }
    
    // MARK: - Data Loading and Saving
    func loadCourses() {
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json") else {
            print("courses.json not found in main bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            availableCourses = try JSONDecoder().decode([Course].self, from: data)
            print("Successfully loaded \(availableCourses.count) courses")
        } catch {
            print("Error loading courses: \(error)")
        }
    }
    
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "userProgress"),
           let decodedProgress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.userProgress = decodedProgress
        }
    }
    
    func saveProgress() {
        if let encodedProgress = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(encodedProgress, forKey: "userProgress")
        }
    }
    
    // MARK: - Lesson and Exercise Navigation
    func startLesson(_ lesson: Lesson) {
        currentExerciseIndex = 0
        currentLesson = lesson
        isInExerciseView = true
    }
    
    // Handles completing an exercise and updating user progress
    func completeCurrentExercise() {
        guard let currentLesson = currentLesson else { return }
        
        if currentExerciseIndex < currentLesson.exercises.count - 1 {
            // Move to the next exercise
            currentExerciseIndex += 1
        } else {
            // Lesson completed
            completeLesson(currentLesson)
        }
    }
    
    func completeLesson(_ lesson: Lesson) {
        if !userProgress.completedLessons.contains(lesson.id) {
            // Create a new updated progress with the lesson ID added to completedLessons
            var updatedProgress = userProgress
            updatedProgress.completedLessons.append(lesson.id)
            userProgress = updatedProgress
            updateProgress(xpGained: 10, wordsLearned: 5)
            saveProgress()
        }
        
        currentLesson = nil
        currentExerciseIndex = 0
        isInExerciseView = false
    }
    
    // MARK: - Progress Updates
    private func updateProgress(xpGained: Int, wordsLearned: Int) {
        var updatedProgress = userProgress
        updatedProgress.xpPoints += xpGained
        updatedProgress.dailyXPEarned += xpGained
        updatedProgress.wordsLearned += wordsLearned
        
        // Check if it's a new day for daily goals
        if !Calendar.current.isDate(updatedProgress.lastLoginDate, inSameDayAs: Date()) {
            updatedProgress.dailyXPEarned = xpGained // Reset for new day
            updatedProgress.currentStreak += 1 // Only increment streak on new day
            updatedProgress.lastLoginDate = Date()
        }
        
        userProgress = updatedProgress
    }
    
    // Add XP points when completing exercises
    func addXP(_ points: Int) {
        var updatedProgress = userProgress
        updatedProgress.xpPoints += points
        updatedProgress.dailyXPEarned += points
        userProgress = updatedProgress
        saveProgress()
    }
    
    // Method to increment words learned count
    func learnNewWords(_ count: Int) {
        var updatedProgress = userProgress
        updatedProgress.wordsLearned += count
        userProgress = updatedProgress
        saveProgress()
    }
}