//
//  DailyGoalProgressView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Lessons/DailyGoalProgressView.swift
import SwiftUI

struct DailyGoalProgressView: View {
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Daily Goal")
                .font(.caption)
                .foregroundColor(theme.textSecondary)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(theme.progressBackground)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]), // Duolingo-like gradient
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: min(CGFloat(appState.userProgress.dailyXPEarned) / CGFloat(appState.userProgress.dailyXPGoal) * geometry.size.width, geometry.size.width), height: 8) // Progress calculation
                }
            }
            .frame(height: 8)

            Text("\(appState.userProgress.dailyXPEarned)/\(appState.userProgress.dailyXPGoal) XP")
                .font(.caption)
                .foregroundColor(theme.textSecondary)
        }
    }
}