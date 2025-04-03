//
//  DuolingoListeningView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI

struct DuolingoListeningView: View {
    @StateObject private var viewModel: ListeningExerciseViewModel
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    
    @FocusState private var isTextFieldFocused: Bool
    
    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: ListeningExerciseViewModel(lesson: lesson, exerciseIndex: 0))
    }
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea() // Set background
            
            if let exercise = viewModel.currentExercise {
                VStack(spacing: 0) {
                    // Header with streak, progress and hearts
                    ExerciseHeaderView(
                        streakCount: viewModel.streakCount,
                        progressValue: viewModel.progressValue,
                        heartsCount: viewModel.heartsCount
                    )
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Exercise prompt
                        Text(exercise.promptTitle ?? "Write what you hear")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                            .padding(.top, 20)
                        
                        // Audio controls section
                        ZStack {
                            // Background rectangle for the buttons
                            RoundedRectangle(cornerRadius: 8)
                                .fill(theme.background)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                .frame(width: 200, height: 75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(theme.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                            
                            HStack(spacing: 0) {
                                // Speaker button for normal speed
                                SpeakerButton(
                                    isPlaying: viewModel.isPlaying && !viewModel.isPlayingSlow,
                                    action: { viewModel.playAudio(slow: false) }
                                )
                                .frame(width: 98)
                                
                                // Vertical divider
                                Rectangle()
                                    .fill(theme.textSecondary.opacity(0.3))
                                    .frame(width: 1, height: 40)
                                
                                // Slow playback button with turtle icon
                                SlowPlaybackButton(
                                    isPlaying: viewModel.isPlaying && viewModel.isPlayingSlow,
                                    action: { viewModel.playAudio(slow: true) }
                                )
                                .frame(width: 98)
                            }
                            .frame(width: 200, height: 75)
                        }
                        .padding(.vertical, 5)
                        
                        VStack(spacing: 30) {
                            ZStack(alignment: .topLeading) {
                                // Lines for the answer area.
                                VStack(spacing: 60) {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(theme.textSecondary.opacity(0.5))
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(theme.textSecondary.opacity(0.5))
                                }
                                .frame(height: 150)
                                
                                selectedWordsView(correctAnswer: exercise.correctAnswer ?? [])
                                    .padding(.horizontal, 4)
                            }
                            
                            // Use available words for pill selection if they exist
                            if let availableWords = exercise.availableWords, !availableWords.isEmpty {
                                availableWordsView(availableWords: availableWords)
                            }
                        }
                        .padding(.top, 1)
                        
                        // Show the correct answer if the user got it wrong
                        if viewModel.isAnswered && !viewModel.isCorrect {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correct answer:")
                                    .font(.headline)
                                    .foregroundColor(theme.textSecondary)
                                
                                Text(exercise.correctAnswer?.joined(separator: " ") ?? "")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(theme.success)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                        }
                        
                        // Feedback view when answered
                        if viewModel.isAnswered {
                            AnswerFeedbackView(
                                isCorrect: viewModel.isCorrect,
                                message: viewModel.isCorrect ? "That's right!" : "Not quite right"
                            )
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(theme.background)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                        
                        // Use shared AnswerControlView component for consistent UI
                        AnswerControlView(
                            isAnswered: viewModel.isAnswered,
                            isCorrect: viewModel.isCorrect,
                            hasSelectedAnswer: !viewModel.selectedWords.isEmpty,
                            onCheck: {
                                viewModel.checkAnswer()
                            },
                            onContinue: {
                                if viewModel.isCorrect {
                                    appState.completeCurrentExercise()
                                    if appState.currentLesson != nil {
                                        viewModel.loadExercise(at: appState.currentExerciseIndex)
                                    }
                                }
                                viewModel.resetExercise()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Text("Loading...")
                    .foregroundColor(theme.textPrimary)
            }
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
    
    // Selected words view - similar to translation exercise
    private func selectedWordsView(correctAnswer: [String]) -> some View {
        FlowLayout(spacing: 10, lineSpacing: 60) {
            if viewModel.isAnswered && viewModel.isCorrect {
                // Show correct answer
                ForEach(correctAnswer, id: \.self) { word in
                    WordPill(
                        word: word,
                        isSelected: true,
                        correctAnswer: correctAnswer,
                        isAnswered: viewModel.isAnswered,
                        isCorrect: viewModel.isCorrect,
                        onTap: { }
                    )
                }
            } else {
                ForEach(viewModel.selectedWords, id: \.self) { word in
                    WordPill(
                        word: word,
                        isSelected: true,
                        correctAnswer: correctAnswer,
                        isAnswered: viewModel.isAnswered,
                        isCorrect: viewModel.isCorrect,
                        onTap: {
                            if !viewModel.isAnswered {
                                viewModel.selectedWords.removeAll { $0 == word }
                            }
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // Available words view - similar to translation exercise
    private func availableWordsView(availableWords: [String]) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                // First row
                HStack(spacing: 10) {
                    let halfCount = (availableWords.count + 1) / 2
                    ForEach(Array(availableWords.prefix(halfCount)), id: \.self) { word in
                        if !viewModel.selectedWords.contains(word) {
                            // Highlight incorrect words after answering
                            let isIncorrect = viewModel.isAnswered && !viewModel.isCorrect && !getCorrectAnswer().contains(word)
                            WordPill(
                                word: word,
                                isSelected: false,
                                isHighlighted: isIncorrect,
                                correctAnswer: getCorrectAnswer(),
                                isAnswered: viewModel.isAnswered,
                                isCorrect: viewModel.isCorrect,
                                onTap: {
                                    if !viewModel.isAnswered && !viewModel.selectedWords.contains(word) {
                                        viewModel.selectedWords.append(word)
                                    }
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Second row
                HStack(spacing: 10) {
                    let halfCount = (availableWords.count + 1) / 2
                    ForEach(Array(availableWords.dropFirst(halfCount)), id: \.self) { word in
                        if !viewModel.selectedWords.contains(word) {
                            let isIncorrect = viewModel.isAnswered && !viewModel.isCorrect && !getCorrectAnswer().contains(word)
                            WordPill(
                                word: word,
                                isSelected: false,
                                isHighlighted: isIncorrect,
                                correctAnswer: getCorrectAnswer(),
                                isAnswered: viewModel.isAnswered,
                                isCorrect: viewModel.isCorrect,
                                onTap: {
                                    if !viewModel.isAnswered && !viewModel.selectedWords.contains(word) {
                                        viewModel.selectedWords.append(word)
                                    }
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }
    
    // Helper to get the correct answer
    private func getCorrectAnswer() -> [String] {
        viewModel.currentExercise?.correctAnswer ?? []
    }
}

struct DuolingoListeningView_Previews: PreviewProvider {
    static var previews: some View {
        // Create preview data for the view
        let mockLesson = Lesson(
            id: UUID(),
            title: "Listening Practice",
            icon: "ear.fill",
            type: .listening,
            requiredXP: 0,
            isLocked: false,
            exercises: [
                Exercise(
                    id: UUID(),
                    type: .listening,
                    promptTitle: "Write what you hear",
                    pinyin: "nǐ hǎo",
                    characters: "你好",
                    correctAnswer: ["Hello", "Hi"],
                    availableWords: ["Hello", "Goodbye", "Hi", "Thank", "You", "Morning"],
                    leftItems: nil,
                    rightItems: nil,
                    rightItemsPinyin: nil,
                    imageOptions: nil,
                    audioURL: "mock",
                    strokeCharacters: nil
                )
            ]
        )
        
        return NavigationView {
            DuolingoListeningView(lesson: mockLesson)
                .environmentObject(ChineseAppState())
                .environment(\.theme, .light)
        }
    }
}
