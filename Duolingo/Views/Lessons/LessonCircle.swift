//
//  LessonCircle.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct LessonCircle: View {
    let lesson: Lesson
    @Environment(\.theme) var theme
    @EnvironmentObject var appState: ChineseAppState
    
    // MARK: - Properties
    private let circleSize = CGSize(width: 65, height: 60)
    private let offsetY: CGFloat = -8
    
    private var circleColor: Color {
        if lesson.isLocked {
            return theme.button.opacity(0.3)
        } else if appState.userProgress.completedLessons.contains(lesson.id) {
            return Color(red: 0.95, green: 0.77, blue: 0.06)
        } else {
            return theme.button
        }
    }
    
    private var shadowColor: Color {
        if lesson.isLocked {
            return theme.button.opacity(0.3)
        } else if appState.userProgress.completedLessons.contains(lesson.id) {
            return Color(red: 0.95, green: 0.77, blue: 0.06).opacity(0.7)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Bottom layer (shadow)
            ellipseShape
                .fill(shadowColor)
                .frame(width: circleSize.width, height: circleSize.height)
            
            // Top layer (main content)
            ellipseShape
                .fill(circleColor)
                .frame(width: circleSize.width, height: circleSize.height)
                .offset(y: offsetY)
                .overlay {
                    ellipseStroke
                    iconStack
                }
        }
    }
    
    // MARK: - Subviews
    private var ellipseShape: some Shape {
        Ellipse()
    }
    
    private var ellipseStroke: some View {
        ellipseShape
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            .frame(width: circleSize.width, height: circleSize.height)
            .offset(y: offsetY)
    }
    
    private var iconStack: some View {
        ZStack {
            // Main icon
            Image(systemName: lesson.icon)
                .font(.system(size: 24))
                .foregroundColor(lesson.isLocked ? theme.iconDisabledColor : theme.iconColor)
                .offset(y: offsetY)
            
            // Lock icon for locked lessons
            if lesson.isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16))
                    .foregroundColor(theme.iconDisabledColor)
                    .offset(y: offsetY)
            }
            
            // Crown icon for completed lessons
            if appState.userProgress.completedLessons.contains(lesson.id) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 16))
                    .foregroundColor(theme.success)
                    .offset(x: 20, y: -25 + offsetY)
            }
        }
    }
}

// MARK: - Preview
struct LessonCircle_Previews: PreviewProvider {
    static var previews: some View {
        LessonCircle(lesson: Lesson(
            id: UUID(),
            title: "Basics",
            icon: "book.fill",
            type: .translation,    // Added required parameter
            requiredXP: 10,        // Added required parameter
            isLocked: false,
            exercises: []
        ))
        .environmentObject(ChineseAppState())
        .environment(\.theme, AppTheme.systemTheme())
    }
}
