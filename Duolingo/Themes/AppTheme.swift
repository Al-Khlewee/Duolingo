//
//  AppTheme.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct AppTheme {
    let textPrimary: Color
    let textSecondary: Color
    let accent: Color          // General accent color (Duolingo green)
    let background: Color      // Main background
    let cardBackground: Color  // Background for cards/sections
    let button: Color          // General button color
    let buttonDisabled: Color
    let progress: Color        // For progress bars
    let progressBackground: Color
    let success: Color         // For correct answers, checkmarks
    let failure: Color         // For incorrect answers, xmarks
    let highlight: Color       // For selected word pills
    let iconColor: Color       // For icons in LessonCircle
    let iconDisabledColor: Color // For disabled icons
    // Duolingo-branded color constants
    private static let duoGreen = Color(red: 88/255, green: 204/255, blue: 2/255)        // #58CC02
    private static let duoBlue = Color(red: 28/255, green: 176/255, blue: 246/255)       // #1CB0F6
    private static let duoRed = Color(red: 255/255, green: 75/255, blue: 75/255)         // #FF4B4B
    private static let duoOrange = Color(red: 255/255, green: 150/255, blue: 0/255)      // #FF9600
    private static let duoYellow = Color(red: 255/255, green: 200/255, blue: 0/255)      // #FFC800
    private static let duoPurple = Color(red: 175/255, green: 82/255, blue: 222/255)     // #AF52DE
    private static let duoGray = Color(red: 118/255, green: 118/255, blue: 118/255)      // #767676
    private static let duoLightGray = Color(red: 229/255, green: 229/255, blue: 229/255) // #E5E5E5
    private static let duoDarkGray = Color(red: 77/255, green: 77/255, blue: 77/255)     // #4D4D4D
    private static let duoDarkest = Color(red: 41/255, green: 41/255, blue: 41/255)      // #292929
    private static let duoCharcoal = Color(red: 28/255, green: 28/255, blue: 28/255)     // #1C1C1C

    // Dark theme (based on actual Duolingo dark mode)
    static let dark = AppTheme(
        textPrimary: .white,
        textSecondary: Color(white: 0.7),
        accent: duoGreen,
        background: duoCharcoal,
        cardBackground: duoDarkGray,
        button: duoGreen,
        buttonDisabled: duoGray,
        progress: duoGreen,
        progressBackground: duoLightGray.opacity(0.2),
        success: duoGreen,
        failure: duoRed,
        highlight: duoBlue,
        iconColor: .white,
        iconDisabledColor: duoGray
    )
    
    // Light theme (based on actual Duolingo light mode)
    static let light = AppTheme(
        textPrimary: duoDarkest,
        textSecondary: duoDarkGray,
        accent: duoGreen,
        background: .white,
        cardBackground: .white,
        button: duoGreen,
        buttonDisabled: duoLightGray.opacity(0.5),
        progress: duoGreen,
        progressBackground: duoLightGray,
        success: duoGreen,
        failure: duoRed,
        highlight: duoYellow,
        iconColor: duoDarkest,
        iconDisabledColor: duoGray
    )
}

// Helper extension for automatic theme switching in previews
extension AppTheme {
    static func systemTheme() -> AppTheme {
        // Get the current system appearance
        let currentAppearance = UITraitCollection.current.userInterfaceStyle
        return currentAppearance == .dark ? .dark : .light
    }
}

// Make the theme accessible via the environment
extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = AppTheme.light // Set light theme as default to match Duolingo's default
}