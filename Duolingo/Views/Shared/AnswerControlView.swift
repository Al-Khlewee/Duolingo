//
//  AnswerControlView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct AnswerControlView: View {
    let isAnswered: Bool
    let isCorrect: Bool
    let hasSelectedAnswer: Bool
    let onCheck: () -> Void
    let onContinue: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 10) {
            if isAnswered {
                // Show feedback message
                Text(isCorrect ? "Great job!" : "Try again!")
                    .font(.headline)
                    .foregroundColor(isCorrect ? theme.success : theme.failure)
                    .padding(.bottom, 5)
                
                // Continue button
                DuolingoButton(
                    text: "Continue",
                    buttonType: isCorrect ? .success : .failure,
                    isEnabled: true,
                    action: onContinue
                )
            } else {
                // Check button
                DuolingoButton(
                    text: "Check",
                    buttonType: .primary,
                    isEnabled: hasSelectedAnswer,
                    action: onCheck
                )
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    VStack {
        AnswerControlView(
            isAnswered: false,
            isCorrect: false,
            hasSelectedAnswer: true,
            onCheck: {},
            onContinue: {}
        )
        
        AnswerControlView(
            isAnswered: true,
            isCorrect: true,
            hasSelectedAnswer: true,
            onCheck: {},
            onContinue: {}
        )
        
        AnswerControlView(
            isAnswered: true,
            isCorrect: false, 
            hasSelectedAnswer: true,
            onCheck: {},
            onContinue: {}
        )
    }
    .padding()
    .environment(\.theme, AppTheme.systemTheme())
}
