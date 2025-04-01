//
//  ProfileView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Header
                    profileHeader
                    
                    // Stats Section
                    statsSection
                    
                    // Theme Settings
                    ThemeSwitcher()
                    
                    // Additional Settings
                    settingsSection
                }
                .padding(.horizontal)
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Picture
            ZStack {
                Circle()
                    .fill(theme.accent)
                    .frame(width: 100, height: 100)
                
                Text("👨‍🎓")
                    .font(.system(size: 50))
            }
            .padding(.top, 20)
            
            // Username
            Text("Duo Learner")
                .font(.title2.bold())
                .foregroundColor(theme.textPrimary)
                
            // Level Info
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Level 5")
                    .foregroundColor(theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Stats")
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            
            HStack(spacing: 20) {
                statItem(title: "Streak", value: "\(appState.userProgress.currentStreak)", icon: "flame.fill", color: .orange)
                statItem(title: "XP", value: "\(appState.userProgress.xpPoints)", icon: "hexagon.fill", color: .blue)
                statItem(title: "Words", value: "\(appState.userProgress.wordsLearned)", icon: "book.fill", color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func statItem(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.title3.bold())
                .foregroundColor(theme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            
            Button(action: {}) {
                settingsRow(title: "Notifications", icon: "bell.fill")
            }
            
            Divider().padding(.leading, 56)
            
            Button(action: {}) {
                settingsRow(title: "Audio Settings", icon: "speaker.wave.2.fill")
            }
            
            Divider().padding(.leading, 56)
            
            Button(action: {}) {
                settingsRow(title: "Language", icon: "globe")
            }
            
            Divider().padding(.leading, 56)
            
            Button(action: {}) {
                settingsRow(title: "Help", icon: "questionmark.circle.fill")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.bottom, 40)
    }
    
    private func settingsRow(title: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(theme.accent)
                .frame(width: 28)
            
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(theme.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(theme.textSecondary)
                .font(.system(size: 14))
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    Group {
        ProfileView()
            .environmentObject(ChineseAppState())
            .environment(\.theme, .light)
            .previewDisplayName("Light Mode")
        
        ProfileView()
            .environmentObject(ChineseAppState())
            .environment(\.theme, .dark)
            .previewDisplayName("Dark Mode")
    }
}