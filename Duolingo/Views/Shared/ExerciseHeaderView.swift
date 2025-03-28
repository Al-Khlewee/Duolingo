//
//  ExerciseHeaderView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct ExerciseHeaderView: View {
    let streakCount: Int
    let progressValue: CGFloat
    let heartsCount: Int
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(streakCount) IN A ROW")
                .foregroundColor(theme.accent)
                .font(.caption)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .foregroundColor(theme.textSecondary)
                
                // Use the shared DuolingoProgressBar
                DuolingoProgressBar(progress: progressValue)
                    .frame(height: 20)
                
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(theme.failure)
                        .font(.system(size: 24))
                    Text("\(heartsCount)")
                        .foregroundColor(theme.textPrimary)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack {
        ExerciseHeaderView(streakCount: 3, progressValue: 0.5, heartsCount: 5)
        ExerciseHeaderView(streakCount: 0, progressValue: 0.25, heartsCount: 3)
        ExerciseHeaderView(streakCount: 10, progressValue: 0.75, heartsCount: 4)
    }
    .padding()
    .background(Color(.systemBackground))
    .environment(\.theme, .light)
}