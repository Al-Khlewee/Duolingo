//
//  AudioPlayerView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct AudioPlayerView: View {
    let isPlaying: Bool
    let progress: Double
    let action: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 12) {
            // Custom audio button with play/pause icon
            Button(action: action) {
                ZStack {
                    // Bottom layer (shadow)
                    Circle()
                        .fill(theme.accent.opacity(0.7))
                        .frame(width: 80, height: 80)
                    
                    // Top layer (main button)
                    Circle()
                        .fill(theme.accent)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                                .foregroundColor(theme.textPrimary)
                        )
                        .offset(y: -4) // 3D effect
                }
                .padding(.bottom, 10)
            }
            
            // Audio progress bar
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: theme.accent))
                .frame(width: 200)
        }
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            AudioPlayerView(isPlaying: false, progress: 0.0, action: {})
            AudioPlayerView(isPlaying: true, progress: 0.45, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}