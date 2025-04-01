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
    @State private var showStatDetails: Bool = false
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Background with duo pattern
                backgroundLayer
                
                VStack(spacing: 0) {
                    // Top header bar
                    statsBarView
                        .transition(.move(edge: .top))
                        .zIndex(1)
                    
                    // Course title with animated transitions
                    courseTitleView
                        .zIndex(0)
                    
                    // Scrollable Content with bouncy effect
                    ScrollView {
                        courseListView
                            .padding(.top, 10)
                    }
                    .refreshable {
                        // Pull to refresh animation and functionality
                        withAnimation {
                            // Here we would typically reload data
                            // For now we'll just add a visual feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        }
                    }
                }
            }
            .background(theme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Subviews
    private var backgroundLayer: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            
            // Duolingo-style dotted background pattern
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let dotSize: CGFloat = 4
                let spacing: CGFloat = 25
                
                ForEach(0..<Int(width / spacing), id: \.self) { x in
                    ForEach(0..<Int(height / spacing), id: \.self) { y in
                        Circle()
                            .fill(theme.accent.opacity(0.1))
                            .frame(width: dotSize, height: dotSize)
                            .position(
                                x: CGFloat(x) * spacing,
                                y: CGFloat(y) * spacing
                            )
                    }
                }
            }
            .allowsHitTesting(false)
        }
    }
    
    private var statsBarView: some View {
        VStack(spacing: 12) {
            HStack {
                // Flag with subtle bounce effect on tap
                StatItemView(
                    content: Text(appState.userProgress.countryFlag)
                        .font(.title)
                )
                .scaleEffect(showStatDetails ? 1.05 : 1.0)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        showStatDetails.toggle()
                    }
                }
                
                // Streak with flame animation
                StatItemView(
                    icon: "flame.fill", 
                    color: .orange,
                    value: "\(appState.userProgress.currentStreak)",
                    showAnimation: true
                )
                
                // XP with gem animation
                StatItemView(
                    icon: "hexagon.fill", 
                    color: .blue,
                    value: "\(appState.userProgress.xpPoints)",
                    showBadge: appState.userProgress.xpPoints > 400
                )
                
                // Words with book animation
                StatItemView(
                    icon: "book.fill", 
                    color: .purple,
                    value: "\(appState.userProgress.wordsLearned)"
                )
            }
            .padding(.horizontal, 8)
            
            // Daily Goal Progress with animated fill
            DailyGoalProgressView()
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var courseListView: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(appState.availableCourses.enumerated()), id: \.element.id) { index, course in
                CourseSectionView(course: course)
                    .id(index)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: index)
                    .background(
                        GeometryReader { geo in
                            Color.clear.onUpdate(of: geo.frame(in: .global).minY) { value in
                                updateVisibleCourse(y: value, index: index)
                            }
                        }
                    )
            }
        }
        .padding(.bottom, 60) // Extra padding at bottom for better scrolling experience
    }
    
    private var courseTitleView: some View {
        Group {
            if (!appState.availableCourses.isEmpty) {
                ZStack {
                    // Shadow layer
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.2))
                        .frame(height: 72)
                        .offset(y: 6)
                    
                    // Background layer
                    RoundedRectangle(cornerRadius: 16)
                        .fill(theme.accent.opacity(0.7))
                        .frame(height: 72)
                    
                    // Foreground layer with content
                    courseTitleContent
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: visibleCourseIndex)
            }
        }
    }
    
    private var courseTitleContent: some View {
        HStack(spacing: 0) {
            // Add owl icon for more Duolingo-like feel
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.white.opacity(0.9))
                .frame(width: 40)
                .padding(.leading, 8)
            
            courseTitleText(for: visibleCourseIndex)
                .foregroundColor(Color.white)
                .matchedGeometryEffect(id: "courseTitle", in: animation)
            
            Spacer()
            
            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.3))
            
            // Add more interactive buttons
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 7)) {
                    // Toggle course list (placeholder for now)
                }
            }) {
                Image(systemName: "list.bullet")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.white)
                    .frame(width: 50)
            }
        }
        .frame(height: 72)
        .background(theme.accent)
        .cornerRadius(16)
    }
    
    private func courseTitleText(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(appState.availableCourses[index].title)
                .font(.system(size: 18, weight: .bold))
                .lineLimit(1)
            
            Text(appState.availableCourses[index].subtitle)
                .font(.system(size: 13, weight: .medium))
                .opacity(0.9)
                .lineLimit(1)
        }
        .padding(.leading, 8)
    }
    
    private func updateVisibleCourse(y: CGFloat, index: Int) {
        let threshold = UIScreen.main.bounds.height / 3
        if y < threshold && y > -threshold {
            if visibleCourseIndex != index {
                withAnimation(.easeInOut(duration: 0.2)) {
                    visibleCourseIndex = index
                }
            }
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
