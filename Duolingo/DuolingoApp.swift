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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.theme, getTheme(for: userColorScheme))
                .preferredColorScheme(getPreferredColorScheme())
                .onAppear {
                    // Ensure the appState saves progress when changes occur
                    appState.loadProgress()
                }
                .onChange(of: appState.userProgress) { _ in
                    appState.saveProgress()
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
            return preferredColorScheme == .dark ? .dark : .light
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
