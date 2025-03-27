//
//  UserProgress.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/UserProgress.swift
import Foundation

struct UserProgress: Codable {
    var currentStreak: Int
    var wordsLearned: Int
    var xpPoints: Int
    var completedLessons: [UUID]
    var countryFlag: String = "🇨🇳"
    var dailyXPGoal: Int = 30
    var dailyXPEarned: Int = 0
    var lastLoginDate: Date = Date()
}