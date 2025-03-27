//
//  Course.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/Course.swift
import Foundation

struct Course: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let lessons: [Lesson]
}