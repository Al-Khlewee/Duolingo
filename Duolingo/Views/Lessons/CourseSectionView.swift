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
    @Environment(\.colorScheme) var colorScheme

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
                        // Fixed UUID comparison by ensuring we're passing a UUID to contains()
                        let nextLessonID = course.lessons[index + 1].id
                        LessonConnector(isCompleted: appState.userProgress.completedLessons.contains(nextLessonID))
                    }
                }
            }
            .frame(maxWidth: .infinity) // Ensure it takes up the full width
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.cardBackground)
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.2), 
                       radius: 8, x: 0, y: 2)
        )
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

// Replace #Preview with PreviewProvider to avoid ambiguity
struct CourseSectionView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSectionView(course: Course(id: UUID(), title: "Basics", subtitle: "Learn essentials", lessons: []))
            .environment(\.theme, AppTheme.systemTheme())
            .environmentObject(ChineseAppState())
    }
}

