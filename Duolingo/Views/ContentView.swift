//
//  Tab.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/ContentView.swift
import SwiftUI

enum Tab { //  tab items
    case lessons
    case achievements
    case practice
    case profile
    case social
}

struct ContentView: View {
    @StateObject var appState = ChineseAppState() // App-level state defined once here
    @Environment(\.theme) var theme // Theme
    @Environment(\.colorScheme) var colorScheme // System color scheme
    @State private var selectedTab: Tab = .lessons // track selected tab

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) { // TabView for main navigation
                LessonsScreen() // main lessons screen
                    .tag(Tab.lessons)
                Text("Achievements")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.background)
                    .tag(Tab.achievements)
                Text("Practice")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.background)
                    .tag(Tab.practice)
                Text("Profile")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.background)
                    .tag(Tab.profile)
                Text("Social")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.background)
                    .tag(Tab.social)
            }
            if !appState.isInExerciseView {  // Only show navigation bar when not in exercise view
                bottomNavigationBar // custom bottom navigation bar
            }
        }
        .environmentObject(appState) // Pass down the app state once from the root view
        .preferredColorScheme(colorScheme) // Respect system color scheme
    }

    // custom bottom navigation bar
    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            navButton(iconName: "house.fill", tab: .lessons) // Home icon
            navButton(iconName: "trophy.fill", tab: .achievements) // Achievements icon
            navButton(iconName: "dumbbell.fill", tab: .practice) // Practice icon
            navButton(iconName: "person.fill", tab: .profile) // Profile icon
            navButton(iconName: "person.2.fill", tab: .social) // Social icon
        }
        .padding(.vertical, 10)
        .background(theme.background) // background color
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(theme.textSecondary.opacity(0.2)), // Lighter separator line
            alignment: .top
        )
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: -2) // Add subtle shadow
    }

    // navigation button
    private func navButton(iconName: String, tab: Tab) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack(spacing: 3) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == tab ? theme.accent : theme.textSecondary)
                
                // Add small indicator dot for selected tab
                if selectedTab == tab {
                    Circle()
                        .fill(theme.accent)
                        .frame(width: 4, height: 4)
                        .padding(.top, 2)
                } else {
                    Spacer()
                        .frame(height: 6)
                }
            }
            .frame(maxWidth: .infinity) // Distribute buttons evenly
        }
    }
}

// Fix Preview by using the PreviewProvider protocol
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.theme, AppTheme.systemTheme())
    }
}
