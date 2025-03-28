//
//  DuolingoTranslationView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

// Views/Exercises/DuolingoTranslationView.swift
import SwiftUI

struct DuolingoTranslationView: View {
    @StateObject private var viewModel: DuolingoTranslationViewModel
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme // Access the theme
    
    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: DuolingoTranslationViewModel(lesson: lesson, exerciseIndex: 0))
    }
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea() //  use theme background
            
            if let exercise = viewModel.currentExercise {
                VStack(spacing: 0) {
                    // Use the shared ExerciseHeaderView component
                    ExerciseHeaderView(
                        streakCount: viewModel.streakCount,
                        progressValue: viewModel.progressValue,
                        heartsCount: viewModel.heartsCount
                    )
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(exercise.promptTitle ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                            .padding(.top, 20)
                        
                        HStack(alignment: .top, spacing: 15) {
                            // Use the shared SpeakerButton component
                            SpeakerButton(
                                isPlaying: viewModel.isPlaying,
                                action: { viewModel.playAudio() }
                            )
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(exercise.pinyin ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textSecondary)
                                Text(exercise.characters ?? "")
                                    .font(.title3)
                                    .foregroundColor(theme.textPrimary)
                                
                                //  visual line using dots.
                                HStack(spacing: 2) {
                                    ForEach(0..<40, id: \.self) { _ in
                                        Circle()
                                            .frame(width: 3, height: 3)
                                            .foregroundColor(theme.textSecondary.opacity(0.5))
                                    }
                                }
                                .padding(.trailing, 20)
                            }
                        }
                        
                        VStack(spacing: 30) {
                            ZStack(alignment: .topLeading) {
                                //  lines for the answer area.
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
                            
                            availableWordsView(availableWords: exercise.availableWords ?? [])
                        }
                        .padding(.top, 1)
                        
                        Spacer()
                        
                        // Use shared AnswerControlView component
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
                // Use shared ExerciseBackButton
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
    
    private func selectedWordsView(correctAnswer: [String]) -> some View {
        FlowLayout(spacing: 10, lineSpacing: 60) {
            if viewModel.isAnswered && viewModel.isCorrect {
                // Show correct answer
                ForEach(correctAnswer, id: \.self) { word in
                    // Use shared WordPill component
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
                    // Use shared WordPill component
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
                            // Use shared WordPill component
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
                            // Use shared WordPill component
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
    
    private func getCorrectAnswer() -> [String] {
        viewModel.currentExercise?.correctAnswer ?? []
    }
}



