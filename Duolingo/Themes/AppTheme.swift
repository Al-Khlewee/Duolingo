//
//  AppTheme.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Themes/AppTheme.swift
import SwiftUI

struct AppTheme {
    let textPrimary: Color
    let textSecondary: Color
    let accent: Color          // General accent color.
    let background: Color      // Main background.
    let cardBackground: Color  // Background for cards/sections.
    let button: Color          // General button color.
    let buttonDisabled: Color
    let progress: Color        // For progress bars.
    let progressBackground: Color
    let success: Color         // For correct answers, checkmarks.
    let failure: Color         // For incorrect answers, xmarks.
    let highlight: Color      // e.g., for selected word pills
    let iconColor: Color       //  icons in LessonCircle
    let iconDisabledColor: Color // icons in LessonCircle
    let lessonConnector: Color

    // Example of a "dark mode" theme.
    static let dark = AppTheme(
        textPrimary: .white,
        textSecondary: Color(white: 0.7),
        accent: Color(red: 0.58, green: 0.87, blue: 0.35),  // Duolingo green
        background: Color(red: 0.11, green: 0.11, blue: 0.12),
        cardBackground: Color(red: 0.17, green: 0.17, blue: 0.18),
        button: Color(red: 0.22, green: 0.22, blue: 0.23),
        buttonDisabled: Color(red: 0.22, green: 0.22, blue: 0.23).opacity(0.5),
        progress: Color(red: 0.58, green: 0.87, blue: 0.35),
        progressBackground: Color(red: 0.3, green: 0.3, blue: 0.3),
        success: Color(red: 0.58, green: 0.87, blue: 0.35),
        failure: Color(red: 0.92, green: 0.25, blue: 0.25),
        highlight: Color(red: 1.0, green: 0.83, blue: 0.0),
        iconColor: .white,
        iconDisabledColor: Color(white: 0.6),
        lessonConnector: Color(red: 0.58, green: 0.87, blue: 0.35)
    )

    static let light = AppTheme(
        textPrimary: Color(red: 0.13, green: 0.13, blue: 0.13),
        textSecondary: Color(red: 0.45, green: 0.45, blue: 0.45),
        accent: Color(red: 0.28, green: 0.85, blue: 0.35),
        background: Color(red: 0.98, green: 0.98, blue: 0.98),
        cardBackground: .white,
        button: Color(red: 0.95, green: 0.95, blue: 0.95),
        buttonDisabled: Color(red: 0.9, green: 0.9, blue: 0.9),
        progress: Color(red: 0.28, green: 0.85, blue: 0.35),
        progressBackground: Color(red: 0.9, green: 0.9, blue: 0.9),
        success: Color(red: 0.28, green: 0.85, blue: 0.35),
        failure: Color(red: 0.95, green: 0.23, blue: 0.23),
        highlight: Color(red: 1.0, green: 0.83, blue: 0.0),
        iconColor: Color(red: 0.13, green: 0.13, blue: 0.13),
        iconDisabledColor: Color(red: 0.75, green: 0.75, blue: 0.75),
        lessonConnector: Color(red: 0.28, green: 0.85, blue: 0.35)
    )
}

// Make the theme accessible via the environment.  This is crucial for consistent styling.
extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = AppTheme.dark // Default to dark theme.
}