//
//  Lesson.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/Lesson.swift
import Foundation

struct Lesson: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let icon: String
    let type: LessonType
    let requiredXP: Int
    let isLocked: Bool
    var exercises: [Exercise]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }

    enum LessonType: String, Codable, CaseIterable {
        case translation
        case matching
        //  add other lesson types
    }
}