//
//  CourseSectionView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Lessons/CourseSectionView.swift
import SwiftUI

struct CourseSectionView: View {
    let course: Course
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme // Using environment for theme

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            // Course Header
            Text(course.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary) // Using theme colors
            Text(course.subtitle)
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)


            // Vertical Lesson Path
            VStack(spacing: 0) {
                ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                    NavigationLink(
                        destination: exerciseView(for: lesson), // Show appropriate exercise view
                        tag: lesson,
                        selection: Binding<Lesson?>(
                            get: { appState.currentLesson },
                            set: { newValue in
                                if let lesson = newValue {
                                    appState.startLesson(lesson)
                                } else {
                                    appState.currentLesson = nil
                                }
                            }
                        )
                    ) {
                        LessonCircle(lesson: lesson)
                            .id(lesson.id)
                    }
                    .disabled(lesson.isLocked) // Disable locked lessons

                    if index < course.lessons.count - 1 {
                        LessonConnector(isCompleted: appState.userProgress.completedLessons.contains(course.lessons[index + 1].id)) // Show connector
                    }
                }
            }
            .frame(maxWidth: .infinity) // Ensure it takes up the full width
        }
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder //  use ViewBuilder to handle different exercise types
    private func exerciseView(for lesson: Lesson) -> some View {
        if let exercise = lesson.exercises.first {  //  use first exercise as a router
            switch exercise.type {
            case .translation:
                DuolingoTranslationView(lesson: lesson)
                    .environmentObject(appState)
            case .matching:
                DuolingoMatchingView(lesson: lesson)
                    .environmentObject(appState)
            case .imageSelection:
                DuolingoImageSelectionView(lesson: lesson)
                    .environmentObject(appState)
            case .listening:
                DuolingoListeningView(lesson: lesson)
                    .environmentObject(appState)
            }
        } else {
            Text("No exercises available") // Placeholder for lessons without exercises.
        }
    }
}