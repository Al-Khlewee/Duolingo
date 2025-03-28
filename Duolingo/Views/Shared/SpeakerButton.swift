//
//  SpeakerButton.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct SpeakerButton: View {
    let isPlaying: Bool
    let action: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Bottom layer (shadow)
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.accent.opacity(0.7))
                    .frame(width: 50, height: 50)

                // Top layer (main button)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.accent)
                        .frame(width: 50, height: 50)
                    Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill") // Dynamic icon
                        .foregroundColor(theme.textPrimary)
                        .font(.system(size: 20))
                }
                .offset(y: -4)
            }
        }
    }
}

#Preview {
    HStack(spacing: 30) {
        SpeakerButton(isPlaying: false, action: {})
        SpeakerButton(isPlaying: true, action: {})
    }
    .padding()
    .environment(\.theme, .light)
}