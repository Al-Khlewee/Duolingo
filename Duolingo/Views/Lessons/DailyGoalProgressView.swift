//
//  DailyGoalProgressView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct DailyGoalProgressView: View {
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    
    // Constants
    private let barHeight: CGFloat = 8
    private let cornerRadius: CGFloat = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Daily Goal")
                .font(.caption)
                .foregroundColor(theme.textSecondary)
            
            progressBar
            
            Text("\(appState.userProgress.dailyXPEarned)/\(appState.userProgress.dailyXPGoal) XP")
                .font(.caption)
                .foregroundColor(theme.textSecondary)
        }
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                backgroundTrack
                
                // Progress fill
                progressFill(width: calculateProgressWidth(totalWidth: geometry.size.width))
            }
        }
        .frame(height: barHeight)
    }
    
    private var backgroundTrack: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.progressBackground)
            .frame(height: barHeight)
    }
    
    private func progressFill(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(progressGradient)
            .frame(width: width, height: barHeight)
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.yellow, .orange]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func calculateProgressWidth(totalWidth: CGFloat) -> CGFloat {
        let progress = CGFloat(appState.userProgress.dailyXPEarned) / CGFloat(appState.userProgress.dailyXPGoal)
        return min(progress * totalWidth, totalWidth)
    }
}

// MARK: - Preview
struct DailyGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DailyGoalProgressView()
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(mockAppState())
            .environment(\.theme, AppTheme.systemTheme())
    }
    
    static func mockAppState() -> ChineseAppState {
        let appState = ChineseAppState()
        // You could modify user progress here for different preview states
        return appState
    }
}