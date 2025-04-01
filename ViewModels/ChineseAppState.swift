//
//  ChineseAppState.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI
import Combine

// UserProgress model to store user's achievements and progress
struct UserProgress {
    var currentStreak: Int = 3
    var xpPoints: Int = 450
    var wordsLearned: Int = 82
    var completedLessons: Set<String> = []
    var currentLevel: Int = 5
}

class ChineseAppState: ObservableObject {
    @Published var userProgress: UserProgress = UserProgress()
    @Published var isInExerciseView: Bool = false
    @Published var currentCourse: String = "Chinese" // Default course
    
    // Color scheme preference
    @AppStorage("userColorScheme") var userColorScheme: String = "auto"
    
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
    
    // Computed property to get the appropriate AppTheme based on user preference
    var appTheme: AppTheme {
        switch userColorScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            // For auto, we need to determine the system appearance
            // Since we can't directly access that here, we'll default to light
            return .light
        }
    }
    
    // Method to update XP points when completing exercises
    func addXP(_ points: Int) {
        userProgress.xpPoints += points
    }
    
    // Method to mark a lesson as completed
    func completeLesson(_ lessonId: String) {
        userProgress.completedLessons.insert(lessonId)
    }
    
    // Method to increment words learned count
    func learnNewWords(_ count: Int) {
        userProgress.wordsLearned += count
    }
    
    // Method to update streak (would be called daily)
    func updateStreak() {
        userProgress.currentStreak += 1
    }
}