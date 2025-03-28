//
//  DuolingoProgressBar.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct DuolingoProgressBar: View {
    let progress: CGFloat // 0.0 to 1.0
    let height: CGFloat
    
    @Environment(\.theme) var theme
    
    init(progress: CGFloat, height: CGFloat = 20) {
        self.progress = min(max(progress, 0), 1) // Clamp between 0 and 1
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .frame(height: height)
                    .foregroundColor(theme.progressBackground)
                
                // Progress fill
                Capsule()
                    .frame(width: geometry.size.width * progress, height: height)
                    .foregroundColor(theme.progress)
            }
        }
        .frame(height: height)
    }
}

// Variation with custom progress color
struct DuolingoProgressBar2: View {
    let progress: CGFloat
    let progressColor: Color
    let height: CGFloat
    
    @Environment(\.theme) var theme
    
    init(progress: CGFloat, progressColor: Color, height: CGFloat = 20) {
        self.progress = min(max(progress, 0), 1)
        self.progressColor = progressColor
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .frame(height: height)
                    .foregroundColor(theme.progressBackground)
                
                // Progress fill
                Capsule()
                    .frame(width: geometry.size.width * progress, height: height)
                    .foregroundColor(progressColor)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 30) {
        DuolingoProgressBar(progress: 0.3)
        DuolingoProgressBar(progress: 0.7)
        DuolingoProgressBar2(progress: 0.5, progressColor: .orange)
            .frame(height: 20)
    }
    .padding()
    .environment(\.theme, .light)
}