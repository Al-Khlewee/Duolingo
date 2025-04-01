//
//  AnswerFeedbackView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct AnswerFeedbackView: View {
    let isCorrect: Bool
    let message: String?
    
    @Environment(\.theme) var theme
    
    // Initialize with optional message parameter
    init(isCorrect: Bool, message: String? = nil) {
        self.isCorrect = isCorrect
        self.message = message
    }
    
    var body: some View {
        HStack {
            if isCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(theme.success)
                Text(message ?? "Awesome!")
                    .foregroundColor(theme.success)
                    .fontWeight(.bold)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(theme.failure)
                Text(message ?? "Not quite right")
                    .foregroundColor(theme.failure)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // Optional social sharing buttons (customizable)
            HStack(spacing: 15) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(isCorrect ? theme.success : theme.textSecondary)
                Image(systemName: "camera")
                    .foregroundColor(isCorrect ? theme.success : theme.textSecondary)
            }
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

#Preview {
    VStack(spacing: 20) {
        AnswerFeedbackView(isCorrect: true)
        AnswerFeedbackView(isCorrect: false)
        AnswerFeedbackView(isCorrect: true, message: "Perfect!")
        AnswerFeedbackView(isCorrect: false, message: "Try again")
        CheckAnswerButton(hasAnswer: true, onCheck: {})
        CheckAnswerButton(hasAnswer: false, onCheck: {})
    }
    .padding()
    .environment(\.theme, AppTheme.systemTheme())
    .previewLayout(.sizeThatFits)
}
