//
//  LessonCircle.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct LessonCircle: View {
    let lesson: Lesson
    @Environment(\.theme) var theme // Accessing the theme
    @EnvironmentObject var appState: ChineseAppState
    // Use CGSize for width and height
    private let circleSize: CGSize = CGSize(width: 65, height: 60) // Changed height to 80
    private let offsetY: CGFloat = -8

    var body: some View {
        ZStack {
            // Bottom layer (shadow)
            Ellipse() // Changed from Circle() to Ellipse()
                .fill(lesson.isLocked ?
                      theme.button.opacity(0.3) :
                        (appState.userProgress.completedLessons.contains(lesson.id) ?
                         Color(red: 0.95, green: 0.77, blue: 0.06).opacity(0.7) :  // Completed color
                         Color.gray.opacity(0.2)))
                // Use width and height from circleSize
                .frame(width: circleSize.width, height: circleSize.height)

            // Top layer (main content)
            Ellipse()  // Changed from Circle() to Ellipse()
                .fill(lesson.isLocked ?
                      theme.button.opacity(0.3) :
                        (appState.userProgress.completedLessons.contains(lesson.id) ?
                         Color(red: 0.95, green: 0.77, blue: 0.06) : // Completed color
                         theme.button))
                // Use width and height from circleSize
                .frame(width: circleSize.width, height: circleSize.height)
                .offset(y: offsetY)
                .overlay {
                    Ellipse()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1) // Apply the gray stroke
                        .frame(width: circleSize.width, height: circleSize.height)
                        .offset(y: offsetY)
                    ZStack {
                        Image(systemName: lesson.icon)  // Use systemName for icons
                            .font(.system(size: 24))
                            .foregroundColor(lesson.isLocked ? theme.iconDisabledColor : theme.iconColor) // Themed icon colors
                            .offset(y: offsetY)

                        if lesson.isLocked {
                            Image(systemName: "lock.fill") //  use lock icon for locked lessons
                                .font(.system(size: 16))
                                .foregroundColor(theme.iconDisabledColor)
                                .offset(y: offsetY)
                        }

                        if appState.userProgress.completedLessons.contains(lesson.id) {
                            Image(systemName: "crown.fill") //  use crown icon
                                .font(.system(size: 16))
                                .foregroundColor(theme.success) //  use success color
                                .offset(x: 20, y: -25 + offsetY)
                        }
                    }
                }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(ChineseAppState())
        //.environment(\.theme, AppTheme.systemTheme())
}
