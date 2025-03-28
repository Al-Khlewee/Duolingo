//
//  WordPill.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct WordPill: View {
    let word: String
    let isSelected: Bool
    let isHighlighted: Bool
    let correctAnswer: [String]
    let isAnswered: Bool
    let isCorrect: Bool
    let onTap: () -> Void
    
    @Environment(\.theme) var theme
    
    init(
        word: String,
        isSelected: Bool,
        isHighlighted: Bool = false,
        correctAnswer: [String] = [],
        isAnswered: Bool = false,
        isCorrect: Bool = false,
        onTap: @escaping () -> Void
    ) {
        self.word = word
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
        self.correctAnswer = correctAnswer
        self.isAnswered = isAnswered
        self.isCorrect = isCorrect
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(word)
                .foregroundColor(theme.textPrimary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 12)
                .frame(height: 40)
                .background(
                    ZStack {
                        // Shadow layer (bottom) with offset for 3D effect
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.2))
                            .offset(y: 4)
                        // Main content layer with stroke
                        RoundedRectangle(cornerRadius: 5)
                            .fill(backgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                )
        }
        .disabled(isAnswered) // Disable button after answer is submitted
    }
    
    private var backgroundColor: Color {
        if isAnswered {
            if isCorrect {
                return isSelected ? theme.success : theme.button // Correct answer
            } else {
                // Incorrect answer: Highlight selected incorrect words, and highlight unselected incorrect words.
                if isSelected && !correctAnswer.contains(word) {
                    return theme.failure // Selected, but incorrect
                } else if isHighlighted {
                    return theme.failure.opacity(0.3)  // Highlight incorrect, unselected words.
                } else {
                    return theme.button // Regular, unselected word
                }
            }
        } else {
            // Before answering:  Highlight selected words.
            return isSelected ? theme.highlight : theme.button
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            WordPill(word: "Hello", isSelected: false, onTap: {})
            WordPill(word: "World", isSelected: true, onTap: {})
        }
        
        HStack {
            WordPill(
                word: "Correct", 
                isSelected: true,
                correctAnswer: ["Correct"],
                isAnswered: true,
                isCorrect: true,
                onTap: {}
            )
            
            WordPill(
                word: "Incorrect", 
                isSelected: true,
                correctAnswer: ["Right"], 
                isAnswered: true,
                isCorrect: false,
                onTap: {}
            )
        }
    }
    .padding()
    .environment(\.theme, .light)
}