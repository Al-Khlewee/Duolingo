//
//  DuolingoStrokeDrawingView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct DuolingoStrokeDrawingView: View {
    @StateObject private var viewModel: StrokeDrawingViewModel
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    
    // For drawing on the canvas
    @State private var isDrawing = false
    @GestureState private var fingerLocation: CGPoint = .zero
    @State private var canvasSize: CGSize = .zero
    @State private var showHelpSheet = false
    
    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: StrokeDrawingViewModel(lesson: lesson, exerciseIndex: 0))
    }
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with streak count, progress and hearts
                ExerciseHeaderView(
                    streakCount: viewModel.streakCount,
                    progressValue: viewModel.progressValue,
                    heartsCount: viewModel.heartsCount
                )
                
                // Exercise content
                if let character = viewModel.currentCharacter {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Character information card - designed to match translation exercise layout
                            VStack(spacing: 6) {
                                Text(viewModel.currentExercise?.promptTitle ?? "Trace this character" + 
                                     (character.character.isEmpty ? "" : " \"\(character.character)\"") + 
                                     (character.meaning.isEmpty ? "" : " for \"\(character.meaning)\""))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                                    .padding(.top, 16)
                                    .multilineTextAlignment(.center)
                                
                                // Character showcase with speaker button and pinyin above character
                                HStack(alignment: .center, spacing: 15) {
                                    // Speaker button (placeholder for future audio functionality)
                                    Button {
                                        // Future audio playback implementation
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(theme.accent.opacity(0.7))
                                                .frame(width: 50, height: 50)

                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(theme.accent)
                                                    .frame(width: 50, height: 50)
                                                Image(systemName: "speaker.wave.2.fill")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 20))
                                            }
                                            .offset(y: -4)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(character.pinyin)
                                            .font(.subheadline)
                                            .foregroundColor(theme.textSecondary)
                                        Text(character.character)
                                            .font(.system(size: 42))
                                            .fontWeight(.medium)
                                            .foregroundColor(theme.textPrimary)
                                            
                                        // Visual line using dots similar to translation exercise
                                        HStack(spacing: 2) {
                                            ForEach(0..<20, id: \.self) { _ in
                                                Circle()
                                                    .frame(width: 3, height: 3)
                                                    .foregroundColor(theme.textSecondary.opacity(0.5))
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }
                            .padding(.bottom, 10)
                            
                            // Stroke progress indicator 
                            HStack(spacing: 8) {
                                ForEach(0..<character.strokeCount, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(index < viewModel.currentStrokeIndex ? theme.success : theme.textSecondary.opacity(0.3))
                                        .frame(height: 6)
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 12)
                            
                            // Drawing Canvas with improved visual guidance
                            ZStack {
                                // Background grid with light guidelines
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(theme.inputBackground)
                                    .overlay(
                                        ZStack {
                                            // Grid pattern for guidance
                                            VStack {
                                                ForEach(0..<3) { _ in
                                                    Divider().background(theme.accent.opacity(0.15))
                                                    Spacer()
                                                }
                                            }
                                            
                                            HStack {
                                                ForEach(0..<3) { _ in
                                                    Divider().background(theme.accent.opacity(0.15))
                                                    Spacer()
                                                }
                                            }
                                            
                                            // Center guides
                                            Rectangle()
                                                .fill(theme.accent.opacity(0.15))
                                                .frame(height: 1)
                                            
                                            Rectangle()
                                                .fill(theme.accent.opacity(0.15))
                                                .frame(width: 1)
                                        }
                                        .padding(2)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                
                                // Completed strokes from user
                                ForEach(0..<viewModel.userStrokes.count, id: \.self) { strokeIndex in
                                    StrokeShape(points: viewModel.userStrokes[strokeIndex])
                                        .stroke(theme.accent, lineWidth: 8)
                                        .animation(.none, value: viewModel.userStrokes)
                                }
                                
                                // Current stroke being drawn
                                StrokeShape(points: viewModel.currentUserStroke)
                                    .stroke(theme.accent, lineWidth: 8)
                                    .animation(.none, value: viewModel.currentUserStroke)
                                
                                // Hint stroke (shown when user makes a mistake)
                                if viewModel.showStrokeHint, let currentStroke = viewModel.currentStrokePath {
                                    StrokeShape(points: currentStroke.points)
                                        .stroke(theme.textSecondary.opacity(0.5), lineWidth: currentStroke.strokeWidth)
                                        .transition(.opacity)
                                }
                                
                                // Animation overlay (shown when demonstrating the stroke)
                                if viewModel.isShowingAnimation, let currentStroke = viewModel.currentStrokePath {
                                    AnimatedStrokeView(
                                        points: currentStroke.points,
                                        strokeWidth: currentStroke.strokeWidth,
                                        strokeColor: theme.accent,
                                        duration: viewModel.currentCharacter?.animationSpeed ?? 1.0
                                    )
                                    .transition(.opacity)
                                }
                            }
                            .frame(height: 280)
                            .padding(.horizontal)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            self.canvasSize = proxy.size
                                        }
                                }
                            )
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .updating($fingerLocation) { value, fingerLocation, _ in
                                        fingerLocation = value.location
                                    }
                                    .onChanged { value in
                                        let position = value.location
                                        
                                        if !isDrawing {
                                            isDrawing = true
                                            viewModel.startStrokeDrawing(at: position)
                                        } else {
                                            viewModel.continueStrokeDrawing(to: position)
                                        }
                                    }
                                    .onEnded { _ in
                                        isDrawing = false
                                        viewModel.endStrokeDrawing()
                                    }
                            )
                            
                            // Control buttons with improved layout
                            HStack(spacing: 12) {
                                Button {
                                    viewModel.playStrokeAnimation()
                                } label: {
                                    VStack(spacing: 4) {
                                        Image(systemName: "eye.fill")
                                            .font(.system(size: 22))
                                        Text("Show Me")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(theme.accent.opacity(0.15))
                                    .cornerRadius(12)
                                    .foregroundColor(theme.accent)
                                }
                                
                                Button {
                                    // Clear current drawing
                                    viewModel.currentUserStroke = []
                                    if !viewModel.userStrokes.isEmpty {
                                        viewModel.userStrokes.removeLast()
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        Image(systemName: "arrow.counterclockwise")
                                            .font(.system(size: 22))
                                        Text("Clear")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(theme.textSecondary.opacity(0.15))
                                    .cornerRadius(12)
                                    .foregroundColor(theme.textSecondary)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 12)
                        }
                        .padding(.bottom, 80) // Extra padding for the continue button space
                    }
                }
            }
            
            // Bottom Continue button with modern floating effect
            VStack {
                Spacer()
                
                if viewModel.isCorrect {
                    ZStack {
                        // Button background with blur effect
                        RoundedRectangle(cornerRadius: 16)
                            .fill(theme.background)
                            .frame(height: 80)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
                        
                        DuolingoButton(
                            text: "CONTINUE",
                            buttonType: .success,
                            isEnabled: true,
                            action: {
                                appState.completeCurrentExercise()
                                if appState.currentLesson != nil {
                                    viewModel.loadExercise(at: appState.currentExerciseIndex)
                                }
                            }
                        )
                        .padding(.horizontal, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: viewModel.isCorrect)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Feedback overlay
            if viewModel.showFeedback {
                VStack {
                    Text(viewModel.feedbackMessage)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.feedbackMessage.contains("Good") || viewModel.feedbackMessage.contains("complete") ? 
                                    theme.success.opacity(0.9) : theme.failure.opacity(0.9))
                        )
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut, value: viewModel.showFeedback)
                .zIndex(100)
            }
        }
        .sheet(isPresented: $showHelpSheet) {
            StrokeHelpView(theme: theme)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ExerciseBackButton(action: {
                    appState.currentLesson = nil
                })
            }
        }
        .onAppear {
            appState.isInExerciseView = true
        }
        .onDisappear {
            appState.isInExerciseView = false
        }
    }
}

// Custom shape for drawing strokes
struct StrokeShape: Shape {
    var points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard !points.isEmpty else { return path }
        
        path.move(to: points[0])
        
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        return path
    }
}

// Animated stroke view
struct AnimatedStrokeView: View {
    let points: [CGPoint]
    let strokeWidth: CGFloat
    let strokeColor: Color
    let duration: Double
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            AnimatedStrokePath(points: points, progress: progress)
                .stroke(strokeColor, style: StrokeStyle(
                    lineWidth: strokeWidth,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .onAppear {
                    withAnimation(.easeInOut(duration: duration)) {
                        progress = 1.0
                    }
                }
        }
    }
}

struct AnimatedStrokePath: Shape {
    var points: [CGPoint]
    var progress: CGFloat // 0 to 1
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard !points.isEmpty else { return path }
        
        // Calculate total length
        var lengths: [CGFloat] = [0]
        var totalLength: CGFloat = 0
        
        for i in 1..<points.count {
            let dx = points[i].x - points[i-1].x
            let dy = points[i].y - points[i-1].y
            let segmentLength = sqrt(dx*dx + dy*dy)
            totalLength += segmentLength
            lengths.append(totalLength)
        }
        
        let targetDistance = progress * totalLength
        
        // Draw up to the target distance
        path.move(to: points[0])
        var currentIndex = 1
        
        while currentIndex < points.count && lengths[currentIndex-1] < targetDistance {
            if lengths[currentIndex] >= targetDistance {
                // Need to draw partial segment
                let prevPoint = points[currentIndex-1]
                let currentPoint = points[currentIndex]
                let segmentLength = lengths[currentIndex] - lengths[currentIndex-1]
                let segmentProgress = (targetDistance - lengths[currentIndex-1]) / segmentLength
                
                let x = prevPoint.x + (currentPoint.x - prevPoint.x) * segmentProgress
                let y = prevPoint.y + (currentPoint.y - prevPoint.y) * segmentProgress
                
                path.addLine(to: CGPoint(x: x, y: y))
                break
            } else {
                path.addLine(to: points[currentIndex])
                currentIndex += 1
            }
        }
        
        return path
    }
}

// Helper view for stroke drawing help sheet
struct StrokeHelpView: View {
    var theme: AppTheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("How to write Chinese characters")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        helpSection(
                            icon: "1.circle.fill",
                            title: "Stroke Order",
                            description: "Chinese characters must be written following the correct stroke order. Each stroke should be drawn in a specific direction and sequence."
                        )
                        
                        helpSection(
                            icon: "hand.draw.fill",
                            title: "Stroke Direction",
                            description: "Horizontal strokes are drawn from left to right. Vertical strokes are drawn from top to bottom."
                        )
                        
                        helpSection(
                            icon: "arrow.triangle.branch",
                            title: "Basic Strokes",
                            description: "There are eight basic strokes in Chinese characters: horizontal, vertical, left-falling, right-falling, rising, dot, hook, and turning."
                        )
                        
                        helpSection(
                            icon: "eye.fill",
                            title: "Watch Examples",
                            description: "Use the \"Show Me\" button to see how a stroke should be written. You can watch it as many times as you need."
                        )
                        
                        helpSection(
                            icon: "hand.tap.fill",
                            title: "Practice Makes Perfect",
                            description: "Don't worry if you don't get it right the first time. Regular practice will help you develop muscle memory for writing characters correctly."
                        )
                    }
                    .padding()
                    .background(theme.inputBackground)
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func helpSection(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(theme.accent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(theme.textPrimary)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// Preview provider
struct DuolingoStrokeDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DuolingoStrokeDrawingView(lesson: createMockLesson())
                .environmentObject(ChineseAppState())
        }
    }
    
    static func createMockLesson() -> Lesson {
        // Create a simple mock stroke path for the character "一" (one)
        let strokePoints = [
            CGPoint(x: 75, y: 150),
            CGPoint(x: 150, y: 150),
            CGPoint(x: 225, y: 150)
        ]
        
        let strokePath = StrokePath(points: strokePoints)
        
        let strokeCharacter = StrokeCharacter(
            id: UUID(),
            character: "一",
            pinyin: "yī",
            meaning: "one",
            strokeCount: 1,
            strokeOrder: [strokePath],
            animationSpeed: 1.0
        )
        
        let exercise = Exercise(
            id: UUID(),
            type: .strokeDrawing,
            promptTitle: "Trace the Character",
            pinyin: "yī",
            characters: "一",
            correctAnswer: nil,
            availableWords: nil,
            leftItems: nil,
            rightItems: nil,
            rightItemsPinyin: nil,
            imageOptions: nil,
            audioURL: nil,
            strokeCharacters: [strokeCharacter]
        )
        
        return Lesson(
            id: UUID(),
            title: "Basic Strokes",
            icon: "pencil",
            type: .translation,
            requiredXP: 0,
            isLocked: false,
            exercises: [exercise]
        )
    }
}