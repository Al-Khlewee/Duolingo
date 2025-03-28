//
//  AnswerFeedbackView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct AnswerFeedbackView: View {
    let isAnswered: Bool
    let isCorrect: Bool
    let onContinue: () -> Void
    
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                if isCorrect {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(theme.success)
                        Text("Awesome!")
                            .foregroundColor(theme.success)
                            .fontWeight(.bold)
                    }
                } else {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.failure)
                        Text("Not quite right")
                            .foregroundColor(theme.failure)
                            .fontWeight(.bold)
                    }
                }

                Spacer()

                HStack(spacing: 15) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(isCorrect ? theme.success : theme.textSecondary)
                    Image(systemName: "camera")
                        .foregroundColor(isCorrect ? theme.success : theme.textSecondary)
                }
            }

            // Continue Button
            DuolingoButton(
                text: "CONTINUE",
                buttonType: isCorrect ? .success : .failure,
                action: onContinue
            )
        }
    }
}

// Check button for when user is answering
struct CheckAnswerButton: View {
    let hasAnswer: Bool
    let onCheck: () -> Void
    
    var body: some View {
        DuolingoButton(
            text: "CHECK",
            isEnabled: hasAnswer,
            action: onCheck
        )
    }
}

// Unified answer control that shows either the feedback or check button
struct AnswerControlView: View {
    let isAnswered: Bool
    let isCorrect: Bool
    let hasSelectedAnswer: Bool
    let onCheck: () -> Void
    let onContinue: () -> Void
    
    var body: some View {
        if isAnswered {
            AnswerFeedbackView(
                isAnswered: isAnswered,
                isCorrect: isCorrect,
                onContinue: onContinue
            )
        } else {
            CheckAnswerButton(
                hasAnswer: hasSelectedAnswer,
                onCheck: onCheck
            )
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        AnswerFeedbackView(isAnswered: true, isCorrect: true, onContinue: {})
        AnswerFeedbackView(isAnswered: true, isCorrect: false, onContinue: {})
        CheckAnswerButton(hasAnswer: true, onCheck: {})
        CheckAnswerButton(hasAnswer: false, onCheck: {})
    }
    .padding()
    .environment(\.theme, .light)
}