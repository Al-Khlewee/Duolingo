//
//  LessonCircle.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//
import SwiftUI

struct LessonCircle: View {
    let lesson: Lesson
    @Environment(\.theme) var theme
    @EnvironmentObject var appState: ChineseAppState
    @State private var isPressed: Bool = false
    
    // MARK: - Properties
    private let circleSize = CGSize(width: 68, height: 68)
    private let innerCircleSize = CGSize(width: 60, height: 60)
    private let offsetY: CGFloat = -4
    
    private var isCompleted: Bool {
        appState.userProgress.completedLessons.contains(lesson.id)
    }
    
    private var circleColor: Color {
        if lesson.isLocked {
            return theme.buttonDisabled
        } else if isCompleted {
            return Color(red: 0.95, green: 0.77, blue: 0.06) // Duolingo gold
        } else {
            return theme.button
        }
    }
    
    private var shadowColor: Color {
        if lesson.isLocked {
            return theme.buttonDisabled.opacity(0.5)
        } else if isCompleted {
            return Color(red: 0.95, green: 0.77, blue: 0.06).opacity(0.8)
        } else {
            return theme.button.opacity(0.7)
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Bottom shadow (for 3D effect)
            Circle()
                .fill(shadowColor)
                .frame(width: circleSize.width, height: circleSize.height)
                .offset(y: 4)
            
            // Main circle
            Circle()
                .fill(circleColor)
                .frame(width: circleSize.width, height: circleSize.height)
                .overlay(
                    // Inner circle with slight gradient for depth
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    circleColor.opacity(0.9),
                                    circleColor
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: innerCircleSize.width, height: innerCircleSize.height)
                )
                .overlay(
                    // Add "cracked" effect for lessons in progress (not locked and not completed)
                    !lesson.isLocked && !isCompleted ?
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: innerCircleSize.width - 4, height: innerCircleSize.height - 4)
                        .clipShape(
                            CrackedCircle()
                        ) : nil
                )
                .overlay(
                    // Border overlay
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: circleSize.width, height: circleSize.height)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .overlay(iconContent)
                
            // Glow effect for available non-locked lessons
            if !lesson.isLocked && !isCompleted {
                Circle()
                    .fill(circleColor)
                    .frame(width: circleSize.width, height: circleSize.height)
                    .blur(radius: 10)
                    .opacity(0.2)
                    .scaleEffect(1.1)
            }
                
            // Achievement indicator for completed lessons
            if isCompleted {
                ZStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 28, height: 28)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 2)
                        
                    Image(systemName: "crown.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: circleSize.width/2 - 8, y: -circleSize.height/2 + 8)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in self.isPressed = true }
                .onEnded { _ in self.isPressed = false }
        )
    }
    
    // MARK: - Icon Content
    private var iconContent: some View {
        ZStack {
            // Main icon
            Image(systemName: lesson.icon)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(lesson.isLocked ? theme.iconDisabledColor : .white)
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
            
            // Lock icon for locked lessons
            if lesson.isLocked {
                VStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.iconDisabledColor)
                        .background(
                            Circle()
                                .fill(theme.buttonDisabled.opacity(0.3))
                                .frame(width: 24, height: 24)
                        )
                        .padding(.bottom, 5)
                }
            }
        }
    }
}

// Custom shape for the "cracked egg" effect
struct CrackedCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Random "cracks" in the circle
        let crackCount = Int.random(in: 3...5)
        let fullCircle = 2 * CGFloat.pi
        let increment = fullCircle / CGFloat(crackCount)
        
        for i in 0..<crackCount {
            let angle = CGFloat(i) * increment
            let nextAngle = angle + increment
            
            let distortionFactor = CGFloat.random(in: 0.85...0.95)
            let midAngle = (angle + nextAngle) / 2
            
            let startX = rect.midX + cos(angle) * rect.width/2
            let startY = rect.midY + sin(angle) * rect.height/2
            
            let endX = rect.midX + cos(nextAngle) * rect.width/2
            let endY = rect.midY + sin(nextAngle) * rect.height/2
            
            let controlX = rect.midX + cos(midAngle) * rect.width/2 * distortionFactor
            let controlY = rect.midY + sin(midAngle) * rect.height/2 * distortionFactor
            
            if i == 0 {
                path.move(to: CGPoint(x: startX, y: startY))
            }
            
            path.addQuadCurve(
                to: CGPoint(x: endX, y: endY),
                control: CGPoint(x: controlX, y: controlY)
            )
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
struct LessonCircle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Completed lesson
            LessonCircle(lesson: Lesson(
                id: UUID(),
                title: "Completed",
                icon: "star.fill",
                type: .translation,
                requiredXP: 10,
                isLocked: false,
                exercises: []
            ))
            
            // Available lesson
            LessonCircle(lesson: Lesson(
                id: UUID(),
                title: "Available",
                icon: "book.fill",
                type: .matching,
                requiredXP: 10,
                isLocked: false,
                exercises: []
            ))
            
            // Locked lesson
            LessonCircle(lesson: Lesson(
                id: UUID(),
                title: "Locked",
                icon: "questionmark",
                type: .imageSelection,
                requiredXP: 10,
                isLocked: true,
                exercises: []
            ))
        }
        .padding()
        .background(Color(.systemBackground))
        .environmentObject(ChineseAppState())
        .environment(\.theme, AppTheme.systemTheme())
    }
}
