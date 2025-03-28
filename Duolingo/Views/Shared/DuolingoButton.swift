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
            return backgroundColor(theme: theme, isEnabled: isEnabled).opacity(0.7)
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
            RoundedRectangle(cornerRadius: 12)
                .fill(buttonType.shadowColor(theme: theme, isEnabled: isEnabled))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            
            // Button layer
            Button(action: action) {
                Text(text)
                    .fontWeight(.bold)
                    .foregroundColor(isEnabled ? theme.textPrimary : theme.textPrimary.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(buttonType.backgroundColor(theme: theme, isEnabled: isEnabled))
                    )
            }
            .disabled(!isEnabled)
            .offset(y: -4)  // 3D Effect
        }
        .frame(height: 50)
    }
}

#Preview {
    VStack(spacing: 20) {
        DuolingoButton(text: "CHECK", action: {})
        DuolingoButton(text: "CONTINUE", buttonType: .success, action: {})
        DuolingoButton(text: "TRY AGAIN", buttonType: .failure, action: {})
        DuolingoButton(text: "DISABLED", isEnabled: false, action: {})
    }
    .padding()
    .environment(\.theme, .light)
    .previewDisplayName("Light Theme")
}