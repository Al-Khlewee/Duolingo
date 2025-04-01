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
    @Environment(\.theme) var theme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            // Course Header
            courseHeader
            
            // Vertical Lesson Path
            lessonPath
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
    
    // MARK: - Subviews
    private var courseHeader: some View {
        VStack {
            Text(course.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text(course.subtitle)
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
    }
    
    private var lessonPath: some View {
        VStack(spacing: 0) {
            ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                NavigationLink(
                    destination: exerciseView(for: lesson),
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
                .disabled(lesson.isLocked)
                
                if index < course.lessons.count - 1 {
                    let nextLessonID = course.lessons[index + 1].id
                    LessonConnector(isCompleted: appState.userProgress.completedLessons.contains(nextLessonID))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func exerciseView(for lesson: Lesson) -> some View {
        if let exercise = lesson.exercises.first {
            switch exercise.type {
            case .translation:
                DuolingoTranslationView(lesson: lesson)
            case .matching:
                DuolingoMatchingView(lesson: lesson)
            case .imageSelection:
                DuolingoImageSelectionView(lesson: lesson)
            case .listening:
                DuolingoListeningView(lesson: lesson)
            }
        } else {
            Text("No exercises available")
                .foregroundColor(theme.textSecondary)
        }
    }
}

// MARK: - Preview
struct CourseSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let mockLesson = Lesson(
            id: UUID(),
            title: "Numbers",
            icon: "number",
            type: .translation,    // Added required parameter
            requiredXP: 20,        // Added required parameter
            isLocked: false,
            exercises: [
                Exercise(
                    id: UUID(),
                    type: .translation,
                    promptTitle: "Count to ten",  // Changed from prompt to promptTitle
                    pinyin: nil,
                    characters: nil,
                    correctAnswer: ["一二三四五六七八九十"], // Changed to array of strings
                    availableWords: nil,
                    leftItems: nil,
                    rightItems: nil,
                    rightItemsPinyin: nil,
                    imageOptions: nil,
                    audioURL: nil
                )
            ]
        )
        
        let mockCourse = Course(
            id: UUID(),
            title: "Basics",
            subtitle: "Learn essentials",
            lessons: [mockLesson]
        )
        
        return CourseSectionView(course: mockCourse)
            .environment(\.theme, AppTheme.systemTheme())
            .environmentObject(ChineseAppState())
    }
}

