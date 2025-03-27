//
//  LessonConnector.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Lessons/LessonConnector.swift
import SwiftUI

struct LessonConnector: View {
    let isCompleted: Bool
    @Environment(\.theme) var theme // Use theme for consistent styling

    var body: some View {
        VStack(spacing: 4) { //  create a dashed effect
            ForEach(0..<5) { _ in
                Rectangle()
                    .fill(isCompleted ? theme.lessonConnector : theme.progressBackground)
                    .frame(width: 4, height: 4)
            }
        }
        .frame(width: 4, height: 30)
    }
}