//
//  ThemeSwitcher.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct ThemeSwitcher: View {
    @AppStorage("userColorScheme") private var userColorScheme: String = "auto"
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Appearance")
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            
            VStack(spacing: 0) {
                themeButton(title: "Light", systemImage: "sun.max.fill", value: "light")
                
                Divider()
                    .padding(.leading, 56)
                
                themeButton(title: "Dark", systemImage: "moon.fill", value: "dark")
                
                Divider()
                    .padding(.leading, 56)
                
                themeButton(title: "System", systemImage: "gear", value: "auto")
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.cardBackground)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    @ViewBuilder
    private func themeButton(title: String, systemImage: String, value: String) -> some View {
        Button(action: {
            withAnimation {
                userColorScheme = value
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(theme.accent)
                    .frame(width: 28, height: 28)
                
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(theme.textPrimary)
                
                Spacer()
                
                if userColorScheme == value {
                    Image(systemName: "checkmark")
                        .foregroundColor(theme.accent)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Group {
        ThemeSwitcher()
            .environment(\.theme, .light)
            .previewDisplayName("Light Mode")
        
        ThemeSwitcher()
            .environment(\.theme, .dark)
            .previewDisplayName("Dark Mode")
    }
}