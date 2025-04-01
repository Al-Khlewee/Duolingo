//
//  LessonsScreen.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
// Views/Lessons/LessonsScreen.swift
import SwiftUI

struct LessonsScreen: View {
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    @State private var currentCourseIndex: Int = 0
    @State private var visibleCourseIndex: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                statsBarView
                courseTitleView
                
                // Scrollable Content
                ScrollView {
                    courseListView
                }
            }
            .background(theme.background.ignoresSafeArea())
            .navigationBarHidden(true) // Hide the navigation bar to maintain your custom UI
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack style for better behavior on all devices
    }
    
    // MARK: - Subviews
    private var statsBarView: some View {
        VStack(spacing: 8) {
            HStack {
                StatItemView(
                    content: Text(appState.userProgress.countryFlag)
                        .font(.title)
                )
                
                StatItemView(
                    icon: "flame.fill", 
                    color: .orange,
                    value: "\(appState.userProgress.currentStreak)"
                )
                
                StatItemView(
                    icon: "hexagon.fill", 
                    color: .blue,
                    value: "\(appState.userProgress.xpPoints)"
                )
                
                StatItemView(
                    icon: "book.fill", 
                    color: .purple,
                    value: "\(appState.userProgress.wordsLearned)"
                )
            }
            
            // Daily Goal Progress
            DailyGoalProgressView()
        }
        .padding()
    }
    
    private var courseListView: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(Array(appState.availableCourses.enumerated()), id: \.element.id) { index, course in
                CourseSectionView(course: course)
                    .id(index)
                    .background(
                        GeometryReader { geo in
                            Color.clear.onUpdate(of: geo.frame(in: .global).minY) { value in
                                updateVisibleCourse(y: value, index: index)
                            }
                        }
                    )
            }
        }
        .padding()
    }
    
    private var courseTitleView: some View {
        Group {
            if (!appState.availableCourses.isEmpty) {
                ZStack {
                    // Background Layer
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.accent.opacity(0.7))
                        .frame(height: 70)
                    
                    // Foreground Layer
                    courseTitleContent
                }
                .padding(.horizontal)
                .transition(.opacity)
                .animation(.easeInOut, value: visibleCourseIndex)
            }
        }
    }
    
    private var courseTitleContent: some View {
        HStack(spacing: 0) {
            courseTitleText(for: visibleCourseIndex)
                .foregroundColor(theme.textPrimary)
            Spacer()
            Rectangle()
                .fill(theme.textPrimary.opacity(0.3))
                .frame(width: 1, height: 40)
            Image(systemName: "list.bullet")
                .font(.system(size: 18))
                .foregroundColor(theme.textPrimary)
                .frame(width: 40)
        }
        .frame(height: 70)
        .background(theme.accent)
        .cornerRadius(12)
        .offset(y: -4)
    }
    
    private func courseTitleText(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(appState.availableCourses[index].title)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
            Text(appState.availableCourses[index].subtitle)
                .font(.system(size: 12, weight: .medium))
                .opacity(0.8)
                .lineLimit(1)
        }
        .padding(.leading, 16)
    }
    
    private func updateVisibleCourse(y: CGFloat, index: Int) {
        let threshold = UIScreen.main.bounds.height / 3
        if y < threshold && y > -threshold {
            visibleCourseIndex = index
        }
    }
}

// MARK: - View Extensions
extension View {
    func onUpdate<T: Equatable>(of value: T, perform action: @escaping (T) -> Void) -> some View {
        self.onChange(of: value) { newValue in
            action(newValue)
        }
    }
}

// MARK: - Preview Provider
struct LessonsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
            .environmentObject(ChineseAppState())
            .environment(\.theme, AppTheme.systemTheme())
    }
}
