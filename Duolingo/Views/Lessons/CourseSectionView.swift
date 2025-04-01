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
    @State private var animatePath: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Course Header with improved styling
            courseHeader
            
            // Vertical Lesson Path with enhanced visuals
            lessonPath
                .padding(.vertical, 12)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                // Bottom shadow layer for 3D effect
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color.black.opacity(0.4) : Color.gray.opacity(0.2))
                    .offset(y: 6)
                
                // Main background with subtle pattern
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.cardBackground)
                
                // Top subtle pattern overlay
                if colorScheme == .light {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        
                        // Duolingo-style confetti pattern (subtle)
                        ForEach(0..<10) { i in
                            Circle()
                                .fill(theme.accent.opacity(0.03 + Double(i % 3) * 0.01))
                                .frame(width: 4 + CGFloat(i % 5) * 2)
                                .offset(
                                    x: CGFloat.random(in: -100...100),
                                    y: CGFloat.random(in: -150...150)
                                )
                        }
                    }
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: colorScheme == .dark ? Color.black.opacity(0.25) : Color.gray.opacity(0.15), 
            radius: 10, x: 0, y: 4
        )
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                animatePath = true
            }
        }
    }
    
    // MARK: - Subviews
    private var courseHeader: some View {
        HStack(alignment: .center) {
            // Course icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [theme.accent.opacity(0.7), theme.accent]),
                            startPoint: .topLeading, 
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: iconName(for: course.title))
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(course.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(theme.textPrimary)
                
                Text(course.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.textSecondary)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Progress indicator
            progressIndicator
        }
    }
    
    private var progressIndicator: some View {
        let completedCount = course.lessons.filter { appState.userProgress.completedLessons.contains($0.id) }.count
        let totalCount = course.lessons.count
        let progress = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
        
        return ZStack {
            Circle()
                .stroke(theme.progressBackground, lineWidth: 4)
                .frame(width: 48, height: 48)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(theme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 48, height: 48)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(theme.textPrimary)
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
                    HStack {
                        // Lesson circle
                        LessonCircle(lesson: lesson)
                            .id(lesson.id)
                            .scaleEffect(animatePath ? 1.0 : 0.8)
                            .opacity(animatePath ? 1.0 : 0.7)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7)
                                .delay(Double(index) * 0.1),
                                value: animatePath
                            )
                        
                        // Lesson details
                        VStack(alignment: .leading, spacing: 3) {
                            Text(lesson.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(lesson.isLocked ? theme.textSecondary.opacity(0.6) : theme.textPrimary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                                
                                Text("\(lesson.requiredXP) XP")
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.textSecondary.opacity(0.8))
                            }
                        }
                        .padding(.leading, 12)
                        .opacity(lesson.isLocked ? 0.6 : 1.0)
                        
                        Spacer()
                        
                        // Completion indicator or lock
                        if appState.userProgress.completedLessons.contains(lesson.id) {
                            ZStack {
                                Circle()
                                    .fill(theme.success)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        } else if lesson.isLocked {
                            ZStack {
                                Circle()
                                    .fill(theme.buttonDisabled)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(theme.iconDisabledColor)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .disabled(lesson.isLocked)
                
                if index < course.lessons.count - 1 {
                    let nextLessonID = course.lessons[index + 1].id
                    // LessonConnector removed
                    Spacer()
                        .frame(height: 10) // Adding a small spacer instead
                        .padding(.leading, 32)
                }
            }
        }
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
    
    // Return appropriate icon name based on course title
    private func iconName(for courseTitle: String) -> String {
        switch courseTitle.lowercased() {
        case _ where courseTitle.contains("basic"):
            return "1.circle.fill"
        case _ where courseTitle.contains("phrases"):
            return "text.bubble.fill"
        case _ where courseTitle.contains("food"):
            return "fork.knife"
        case _ where courseTitle.contains("travel"):
            return "airplane"
        case _ where courseTitle.contains("people"):
            return "person.2.fill"
        case _ where courseTitle.contains("activity"):
            return "figure.walk"
        default:
            return "book.fill"
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
            type: .translation,
            requiredXP: 20,
            isLocked: false,
            exercises: [
                Exercise(
                    id: UUID(),
                    type: .translation,
                    promptTitle: "Count to ten",
                    pinyin: nil,
                    characters: nil,
                    correctAnswer: ["一二三四五六七八九十"],
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

