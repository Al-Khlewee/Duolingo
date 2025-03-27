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
    @StateObject var appState = ChineseAppState() // App-level state
    @Environment(\.theme) var theme // Theme
    @Environment(\.colorScheme) var colorScheme // System color scheme
    @State private var selectedTab: Tab = .lessons //  track selected tab

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) { // TabView for main navigation
                LessonsScreen() //  main lessons screen
                    .environmentObject(appState) // Pass down the app state
                    .tag(Tab.lessons)
                Text("Achievements") // Placeholder
                    .tag(Tab.achievements)
                Text("Practice") // Placeholder
                    .tag(Tab.practice)
                Text("Profile") // Placeholder
                    .tag(Tab.profile)
                Text("Social") // Placeholder
                    .tag(Tab.social)
            }
            if !appState.isInExerciseView {  // Only show navigation bar when not in exercise view
                bottomNavigationBar //  custom bottom navigation bar
            }
        }
        .preferredColorScheme(colorScheme) // Respect system color scheme
    }

    //  custom bottom navigation bar
    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            navButton(iconName: "house.fill", tab: .lessons) // Home icon
            navButton(iconName: "trophy.fill", tab: .achievements) // Achievements icon
            navButton(iconName: "dumbbell.fill", tab: .practice) // Practice icon
            navButton(iconName: "person.fill", tab: .profile) // Profile icon
            navButton(iconName: "person.2.fill", tab: .social) // Social icon
        }
        .padding(.vertical, 10)
        .background(theme.background) //  background color
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(theme.textSecondary.opacity(0.3)), // Separator line
            alignment: .top
        )
    }

    //  navigation button
    private func navButton(iconName: String, tab: Tab) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == tab ? theme.accent : theme.textSecondary) // Highlight selected
            }
            .frame(maxWidth: .infinity) // Distribute buttons evenly
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(ChineseAppState())
        .environment(\.theme, .light)
}
