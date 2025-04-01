//
//  LessonConnector.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct LessonConnector: View {
    let isCompleted: Bool
    @Environment(\.theme) var theme
    
    // Constants to avoid magic numbers
    private let dotSize: CGFloat = 4
    private let dotCount: Int = 5
    private let totalHeight: CGFloat = 30
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<dotCount, id: \.self) { _ in
                dot
            }
        }
        .frame(width: dotSize, height: totalHeight)
    }
    
    private var dot: some View {
        Rectangle()
            .fill(isCompleted ? theme.lessonConnector : theme.progressBackground)
            .frame(width: dotSize, height: dotSize)
    }
}

// MARK: - Preview
struct LessonConnector_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            LessonConnector(isCompleted: true)
                .previewDisplayName("Completed")
            
            LessonConnector(isCompleted: false)
                .previewDisplayName("Not Completed")
        }
        .padding()
        .environment(\.theme, AppTheme.systemTheme())
    }
}