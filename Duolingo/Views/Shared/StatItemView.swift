//
//  StatItemView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

/// Enhanced stats item view with animations and badges for Duolingo-style UI
struct StatItemView: View {
    // MARK: - Properties
    var icon: String? = nil
    var color: Color? = nil
    var value: String? = nil
    var content: Text? = nil
    var showAnimation: Bool = false
    var showBadge: Bool = false
    
    @State private var isAnimating: Bool = false
    @Environment(\.theme) private var theme
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background capsule
            Capsule()
                .fill(theme.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            // Content
            HStack(spacing: 5) {
                if let content = content {
                    content
                } else if let icon = icon, let color = color, let value = value {
                    ZStack {
                        // Icon with optional animation
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(color)
                            .scaleEffect(isAnimating && showAnimation ? 1.2 : 1.0)
                            .animation(
                                showAnimation ? 
                                Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) : 
                                .default,
                                value: isAnimating
                            )
                        
                        // Badge indicator if needed
                        if showBadge {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                    .frame(width: 26)
                    
                    Text(value)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(theme.textPrimary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(height: 36)
        .onAppear {
            if showAnimation {
                withAnimation {
                    isAnimating = true
                }
            }
        }
    }
}

// MARK: - Preview
struct StatItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            StatItemView(icon: "flame.fill", color: .orange, value: "3", showAnimation: true)
            StatItemView(icon: "hexagon.fill", color: .blue, value: "450", showBadge: true)
            StatItemView(content: Text("🇨🇳").font(.title))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}