//
//  StatItemView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

/// Helper view for statistics items
struct StatItemView: View {
    var icon: String? = nil
    var color: Color? = nil
    var value: String? = nil
    var content: Text? = nil
    
    var body: some View {
        HStack(spacing: 5) {
            if let content = content {
                content
            } else if let icon = icon, let color = color, let value = value {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(value)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity)
    }
}