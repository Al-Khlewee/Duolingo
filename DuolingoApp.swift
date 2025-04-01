//
//  DuolingoApp.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

@main
struct DuolingoApp: App {
    @StateObject private var appState = ChineseAppState()
    @AppStorage("userColorScheme") private var userColorScheme: String = "auto"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.theme, getTheme())
                .preferredColorScheme(getColorScheme())
        }
    }
    
    // Return the appropriate theme based on user preference
    private func getTheme() -> AppTheme {
        switch userColorScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            // For automatic, we determine based on the current system appearance
            // Since we can't directly check that here, we use the colorScheme environment value in views
            return .light // Default to light as a fallback
        }
    }
    
    // Return the appropriate ColorScheme based on user preference
    private func getColorScheme() -> ColorScheme? {
        switch userColorScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil // Use system setting
        }
    }
}