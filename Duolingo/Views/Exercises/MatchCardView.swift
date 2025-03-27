//
//  MatchCardView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Exercises/MatchCardView.swift
import SwiftUI

struct MatchCardView: View {
    let text: String
    let pinyin: String? // Pinyin is optional
    let isLeft: Bool //  distinguish between left and right cards (for styling if needed)
    let isSelected: Bool //  highlight selected cards
    let isMatched: Bool //  dim matched cards
    let action: () -> Void  // Action to perform when the card is tapped
    @Environment(\.theme) var theme

    var body: some View {
        Button(action: action) {
            ZStack {
                // Bottom layer (shadow)
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 80)

                // Top layer with content
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(isSelected ? theme.highlight : Color.gray.opacity(0.2), lineWidth: 1) // Highlight if selected
                        )
                        .overlay(cardContent) //  content of the card
                }
                .frame(height: 80) // Fixed height for consistency
                .offset(y: -4) //  3D effect
            }
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
        .opacity(isMatched ? 0.3 : 1.0) // Reduce opacity if matched
        .disabled(isMatched) // Disable interaction if matched
    }

    //  content of the card
    private var cardContent: some View {
        VStack(spacing: 2) {
            if let pinyin = pinyin {
                // Display pinyin above the text.
                Text(pinyin)
                    .font(.system(size: 14)) // Smaller font for pinyin
                    .foregroundColor(theme.textSecondary)
                    .minimumScaleFactor(0.5) // Allow text to shrink
                    .lineLimit(1) // Prevent wrapping
                Text(text)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(theme.textPrimary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            } else {
                // If no pinyin, display the text centered.
                Text(text)
                    .font(.system(size: 18, weight: .regular)) // Slightly smaller font
                    .foregroundColor(theme.textPrimary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2) // Allow two lines for longer text
                    .multilineTextAlignment(.center) // Center-align multiline text
            }
        }
        .padding(.horizontal, 8) // Padding to prevent text from touching edges
    }
}
