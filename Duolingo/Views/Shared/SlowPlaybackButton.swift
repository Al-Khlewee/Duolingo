//
//  SlowPlaybackButton.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct SlowPlaybackButton: View {
    let isPlaying: Bool
    let action: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Bottom layer (shadow)
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.highlight.opacity(0.7))
                    .frame(width: 50, height: 50)
                // Top layer (main button)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.highlight)
                        .frame(width: 50, height: 50)
                    Image(systemName: isPlaying ? "tortoise.fill" : "tortoise")
                        .foregroundColor(theme.textPrimary)
                        .font(.system(size: 18))
                }
                .offset(y: -4)
            }
        }
    }
}

#Preview {
    HStack(spacing: 30) {
        SlowPlaybackButton(isPlaying: false, action: {})
        SlowPlaybackButton(isPlaying: true, action: {})
    }
    .padding()
    .environment(\.theme, .light)
}