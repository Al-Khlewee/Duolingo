// Views/Exercises/ImageOptionView.swift
import SwiftUI

struct ImageOptionView: View {
    let systemImageName: String
    let isSelected: Bool
    let isCorrect: Bool?
    let englishText: String
    let onTap: () -> Void
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Bottom layer (shadow)
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .offset(y: 4)  // Offset shadow down
                
                // Top layer with content
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: isSelected ? 4 : 1)
                    )
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: systemImageName)
                                .resizable()
                                .scaledToFit()
                                .padding(16)
                                .foregroundColor(theme.textPrimary)
                            
                            Text(englishText)
                                .font(.subheadline)
                                .foregroundColor(theme.textPrimary)
                                .padding(.bottom, 8)
                        }
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? theme.highlight.opacity(0.2) : Color.clear)
                    )
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? theme.success : theme.failure
        }
        return theme.background
    }
    
    private var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? theme.success : theme.failure
        }
        return isSelected ? theme.accent : Color.gray.opacity(0.3)
    }
}

struct ImageOptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageOptionView(
                systemImageName: "pawprint.fill",
                isSelected: true,
                isCorrect: nil,
                englishText: "Dog",
                onTap: {}
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .environment(\.theme, .light)
            
            ImageOptionView(
                systemImageName: "pawprint.fill",
                isSelected: true,
                isCorrect: true,
                englishText: "Dog",
                onTap: {}
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .environment(\.theme, .dark)
        }
    }
}
