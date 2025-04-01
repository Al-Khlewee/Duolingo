//
//  UserProgress.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/UserProgress.swift
import Foundation

struct UserProgress: Codable, Equatable {
    var currentStreak: Int
    var wordsLearned: Int
    var xpPoints: Int
    var completedLessons: [UUID]
    var countryFlag: String = "🇨🇳"
    var dailyXPGoal: Int = 30
    var dailyXPEarned: Int = 0
    var lastLoginDate: Date = Date()
    
    // Implementing Equatable
    static func == (lhs: UserProgress, rhs: UserProgress) -> Bool {
        return lhs.currentStreak == rhs.currentStreak &&
               lhs.wordsLearned == rhs.wordsLearned &&
               lhs.xpPoints == rhs.xpPoints &&
               lhs.completedLessons == rhs.completedLessons &&
               lhs.countryFlag == rhs.countryFlag &&
               lhs.dailyXPGoal == rhs.dailyXPGoal &&
               lhs.dailyXPEarned == rhs.dailyXPEarned &&
               lhs.lastLoginDate == rhs.lastLoginDate
    }
}