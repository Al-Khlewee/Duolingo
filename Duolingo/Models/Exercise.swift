//
//  Exercise.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/Exercise.swift
import Foundation

struct Exercise: Codable, Identifiable {
    let id: UUID
    let type: ExerciseType
    let promptTitle: String? // Optional properties for different exercise types.
    let pinyin: String?
    let characters: String?
    let correctAnswer: [String]?
    var availableWords: [String]?
    let leftItems: [String]?
    let rightItems: [String]?
    let rightItemsPinyin: [String]?

    //  RawRepresentable for JSON (de)serialization and easy debugging.
    enum ExerciseType: String, Codable, CaseIterable {
        case translation
        case matching
        // Add new exercise types here, ensuring the views handle them appropriately.
    }
}