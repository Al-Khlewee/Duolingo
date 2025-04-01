//
//  DuolingoProgressBar.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct DuolingoProgressBar: View {
    let progress: CGFloat // Value between 0 and 1
    @Environment(\.theme) var theme
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background
            Capsule()
                .foregroundColor(theme.progressBackground)
            
            // Progress
            Capsule()
                .frame(width: max(0, min(1, progress)) * UIScreen.main.bounds.width * 0.5)
                .foregroundColor(theme.progress)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DuolingoProgressBar(progress: 0.25)
        DuolingoProgressBar(progress: 0.5)
        DuolingoProgressBar(progress: 0.75)
        DuolingoProgressBar(progress: 1.0)
    }
    .frame(height: 20)
    .padding()
    .environment(\.theme, AppTheme.systemTheme())
}
