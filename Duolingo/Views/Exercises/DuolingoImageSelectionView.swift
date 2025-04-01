// Views/Exercises/DuolingoImageSelectionView.swift
import SwiftUI

struct DuolingoImageSelectionView: View {
    @StateObject private var viewModel: ImageSelectionViewModel
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme
    
    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: ImageSelectionViewModel(lesson: lesson, exerciseIndex: 0))
    }
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            
            if let exercise = viewModel.currentExercise {
                VStack(spacing: 0) {
                    // Use shared ExerciseHeaderView component
                    ExerciseHeaderView(
                        streakCount: viewModel.streakCount,
                        progressValue: viewModel.progressValue,
                        heartsCount: viewModel.heartsCount
                    )
                    
                    // Exercise content
                    VStack(spacing: 20) {
                        Text(exercise.promptTitle ?? "Select the correct image")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                            .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            // Use shared SpeakerButton component
                            SpeakerButton(
                                isPlaying: viewModel.isPlaying,
                                action: { viewModel.playAudio() }
                            )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                if let pinyin = exercise.pinyin {
                                    Text(pinyin)
                                        .font(.callout)
                                        .foregroundColor(theme.textSecondary)
                                }
                                if let characters = exercise.characters {
                                    Text(characters)
                                        .font(.largeTitle)
                                        .fontWeight(.medium)
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                            Spacer() // Push content to the left
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        
                        // Grid of images
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(exercise.imageOptions ?? []) { option in
                                ImageOptionView(
                                    systemImageName: option.systemImageName,
                                    isSelected: viewModel.selectedImageId == option.id,
                                    isCorrect: viewModel.isAnswered ? option.isCorrect : nil,
                                    englishText: option.englishText,
                                    onTap: {
                                        if !viewModel.isAnswered {
                                            viewModel.selectedImageId = option.id
                                        }
                                    }
                                )
                                .frame(height: 200) // Fixed height for more rectangular shape
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        
                        // Use the shared components for feedback and buttons
                        VStack(spacing: 16) {
                            if viewModel.isAnswered {
                                // Use shared AnswerFeedbackView
                                AnswerFeedbackView(isCorrect: viewModel.isCorrect)
                            }
                            
                            // Use shared DuolingoButton component with 3D effect
                            DuolingoButton(
                                text: viewModel.isAnswered ? "CONTINUE" : "CHECK",
                                buttonType: viewModel.isAnswered ? 
                                    (viewModel.isCorrect ? .success : .failure) : .primary,
                                isEnabled: viewModel.selectedImageId != nil || viewModel.isAnswered,
                                action: {
                                    if viewModel.isAnswered {
                                        if viewModel.isCorrect {
                                            appState.completeCurrentExercise()
                                            if appState.currentLesson != nil {
                                                viewModel.loadExercise(at: appState.currentExerciseIndex)
                                            }
                                        }
                                        viewModel.resetExercise()
                                    } else {
                                        viewModel.checkAnswer()
                                    }
                                }
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
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
}

// Preview data
struct DuolingoImageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                DuolingoImageSelectionView(lesson: PreviewData.imageSelectionLesson)
                    .environmentObject(ChineseAppState())
                    .environment(\.theme, .light)
            }
            .previewDisplayName("Light Theme")

            NavigationView {
                DuolingoImageSelectionView(lesson: PreviewData.imageSelectionLesson)
                    .environmentObject(ChineseAppState())
                    .environment(\.theme, .dark)
            }
            .previewDisplayName("Dark Theme")
        }
    }
}

// Preview mock data
enum PreviewData {
    static let imageSelectionLesson = Lesson(
        id: UUID(),
        title: "Animals",
        icon: "pawprint.fill",
        type: .translation,
        requiredXP: 0,
        isLocked: false,
        exercises: [
            Exercise(
                id: UUID(),
                type: .imageSelection,
                promptTitle: "Select the image ",
                pinyin: "gǒu",
                characters: "狗",
                correctAnswer: nil,
                availableWords: nil,
                leftItems: nil,
                rightItems: nil,
                rightItemsPinyin: nil,
                imageOptions: [
                    ImageOption(
                        id: UUID(),
                        systemImageName: "pawprint.fill",
                        isCorrect: true,
                        englishText: "Dog"
                    ),
                    ImageOption(
                        id: UUID(),
                        systemImageName: "theatermasks.fill",
                        isCorrect: false,
                        englishText: "Cat"
                    ),
                    ImageOption(
                        id: UUID(),
                        systemImageName: "leaf.fill",
                        isCorrect: false,
                        englishText: "Bird"
                    ),
                    ImageOption(
                        id: UUID(),
                        systemImageName: "hare.fill",
                        isCorrect: false,
                        englishText: "Rabbit"
                    )
                ],
                audioURL: nil
            )
        ]
    )
}
