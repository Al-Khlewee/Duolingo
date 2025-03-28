//
//  ExerciseBackButton.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct ExerciseBackButton: View {
    let action: () -> Void
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Exit")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(theme.accent)
        }
    }
}

#Preview {
    ExerciseBackButton(action: {})
        .padding()
        .environment(\.theme, .light)
}