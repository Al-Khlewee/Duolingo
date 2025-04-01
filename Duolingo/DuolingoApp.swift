//
//  DuolingoApp.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

@main
struct DuolingoApp: App {
    @StateObject var appState = ChineseAppState() // Create the app state here
    @State private var preferredColorScheme: ColorScheme? = nil
    @AppStorage("userColorScheme") private var userColorScheme: String = "auto"
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.theme, getTheme(for: userColorScheme))
                .preferredColorScheme(getPreferredColorScheme())
                .onAppear {
                    // Ensure the appState saves progress when changes occur
                    appState.loadProgress()
                    // Initialize theme based on current system appearance
                    preferredColorScheme = getPreferredColorScheme()
                }
                .onChange(of: appState.userProgress) { _ in
                    appState.saveProgress()
                }
                .onChange(of: userColorScheme) { newValue in
                    // Update the preferred color scheme when the user changes the theme
                    withAnimation {
                        preferredColorScheme = getPreferredColorScheme()
                    }
                }
                .onChange(of: systemColorScheme) { newValue in
                    // If in auto mode, update when system theme changes
                    if userColorScheme == "auto" {
                        withAnimation {
                            preferredColorScheme = newValue
                        }
                    }
                }
        }
    }
    
    // Helper to determine theme based on user preference
    private func getTheme(for scheme: String) -> AppTheme {
        switch scheme {
        case "dark":
            return .dark
        case "light": 
            return .light
        default: // Auto mode
            let effectiveColorScheme = systemColorScheme // Use current system scheme for auto
            return effectiveColorScheme == .dark ? .dark : .light
        }
    }
    
    // Helper to determine color scheme based on user preference
    private func getPreferredColorScheme() -> ColorScheme? {
        switch userColorScheme {
        case "dark":
            return .dark
        case "light":
            return .light
        default: // Auto mode
            return nil
        }
    }
}
