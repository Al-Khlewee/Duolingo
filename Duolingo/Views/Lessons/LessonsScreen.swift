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
    @Environment(\.theme) var theme  // Access the theme
    @Environment(\.colorScheme) var colorScheme // For system light/dark mode
    @State private var currentCourseIndex: Int = 0
    @State private var visibleCourseIndex: Int = 0  //  track visible course

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                statsBarView // Extracted for readability
                courseTitleView // Extracted for readability

                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(Array(appState.availableCourses.enumerated()), id: \.element.id) { index, course in
                            CourseSectionView(course: course)
                                .id(index)
                                .background(
                                    GeometryReader { geo in // Track position for course title change
                                        Color.clear.onChange(of: geo.frame(in: .global).minY) { value in
                                            let threshold = UIScreen.main.bounds.height / 3
                                            if value < threshold && value > -threshold {
                                                visibleCourseIndex = index //  update the visible course index
                                            }
                                        }
                                    }
                                )
                        }
                    }
                    .padding()
                }
            }
            .background(theme.background.ignoresSafeArea()) // Apply background color
        }
        .preferredColorScheme(colorScheme) // Respect user's preferred color scheme
    }
    
    // MARK: - Subviews
    private var statsBarView: some View {
           VStack(spacing: 8) {
               HStack {
                   Text(appState.userProgress.countryFlag)
                       .font(.title)
                       .frame(maxWidth: .infinity)

                   HStack(spacing: 5) {
                       Image(systemName: "flame.fill")
                           .foregroundColor(.orange)
                       Text("\(appState.userProgress.currentStreak)")
                           .font(.headline)
                   }
                   .frame(maxWidth: .infinity)

                   HStack(spacing: 5) {
                       Image(systemName: "hexagon.fill")
                           .foregroundColor(.blue)
                       Text("\(appState.userProgress.xpPoints)")
                           .font(.headline)
                   }
                   .frame(maxWidth: .infinity)

                   HStack(spacing: 5) {
                       Image(systemName: "book.fill")
                           .foregroundColor(.purple)
                       Text("\(appState.userProgress.wordsLearned)")
                           .font(.headline)
                   }
                   .frame(maxWidth: .infinity)
               }

               // Daily Goal Progress Bar - extracted into its own view
               DailyGoalProgressView()
           }
           .padding()
       }
    
    private var courseTitleView: some View {
        Group { // Group is good for conditional logic
            if !appState.availableCourses.isEmpty {
                ZStack {
                    // Background Layer (Shadow) - Simpler approach
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.accent.opacity(0.7))
                        .frame(height: 70)

                    // Foreground Layer (Main Content)
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
                    .offset(y: -4) // Correct offset for visual layering
                }
                .padding(.horizontal)
                .transition(.opacity) // Keep the transition
                .animation(.easeInOut, value: visibleCourseIndex) // Keep the animation
            }
        }
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
}

// Views/Lessons/LessonsScreen.swift
struct LessonsScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LessonsScreen()
                .environmentObject(previewAppState) // Use a helper property
                .environment(\.theme, .light)
                .previewDisplayName("Loaded Data - Light")
            
            LessonsScreen()
                .environmentObject(previewAppState) // Use a helper property
                .environment(\.theme, .dark)
                .previewDisplayName("Loaded Data - Dark")
        }
    }

    static var previewAppState: ChineseAppState = {
        let appState = ChineseAppState() // Data is loaded in init()
        //You could potentially do additional setup specific for the preview.
        return appState
    }()
}
