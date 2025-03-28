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
                
                // Progress Bar
                DuolingoProgressBar(progress: progressValue)
                
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
    }
}

struct ExerciseBackButton: View {
    let action: () -> Void
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .foregroundColor(theme.accent)
        }
    }
}

#Preview {
    VStack {
        ExerciseHeaderView(streakCount: 3, progressValue: 0.6, heartsCount: 4)
        
        Spacer()
        
        ExerciseBackButton(action: {})
    }
    .padding()
    .environment(\.theme, .light)
}