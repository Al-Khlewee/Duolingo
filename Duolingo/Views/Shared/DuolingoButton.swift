//
//  DuolingoButton.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct DuolingoButton: View {
    // Properties
    let text: String
    let action: () -> Void
    let buttonType: ButtonType
    let isEnabled: Bool
    
    @Environment(\.theme) var theme
    
    // Button types with corresponding colors
    enum ButtonType {
        case primary
        case success
        case failure
        
        func backgroundColor(theme: AppTheme, isEnabled: Bool) -> Color {
            if !isEnabled {
                return theme.buttonDisabled
            }
            
            switch self {
            case .primary:
                return theme.accent
            case .success:
                return theme.success
            case .failure:
                return theme.failure
            }
        }
        
        func shadowColor(theme: AppTheme, isEnabled: Bool) -> Color {
            if !isEnabled {
                return theme.buttonDisabled.opacity(0.5)
            }
            
            switch self {
            case .primary:
                // Darker green shadow for primary buttons
                return Color(red: 88/255 * 0.7, green: 204/255 * 0.7, blue: 2/255 * 0.7)
            case .success:
                return Color(red: 88/255 * 0.7, green: 204/255 * 0.7, blue: 2/255 * 0.7)
            case .failure:
                // Darker red shadow for failure buttons
                return Color(red: 220/255, green: 38/255, blue: 38/255)
            }
        }
    }
    
    // Initialize with default values
    init(
        text: String,
        buttonType: ButtonType = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.buttonType = buttonType
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 8)
                .fill(buttonType.shadowColor(theme: theme, isEnabled: isEnabled))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            
            // Button layer
            Button(action: action) {
                Text(text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(buttonType.backgroundColor(theme: theme, isEnabled: isEnabled))
                    )
            }
            .disabled(!isEnabled)
            .offset(y: -4)  // 3D Effect
        }
        .frame(height: 50)
    }
}

// Replace #Preview with PreviewProvider
struct DuolingoButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DuolingoButton(text: "CHECK", action: {})
            DuolingoButton(text: "CONTINUE", buttonType: .success, action: {})
            DuolingoButton(text: "TRY AGAIN", buttonType: .failure, action: {})
            DuolingoButton(text: "DISABLED", isEnabled: false, action: {})
        }
        .padding()
        .environment(\.theme, AppTheme.systemTheme())
        .previewDisplayName("System Theme")
    }
}