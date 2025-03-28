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
                    // Header section
                    VStack(spacing: 5) {
                        Text("\(viewModel.streakCount) IN A ROW")
                            .foregroundColor(theme.accent)
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .foregroundColor(theme.textSecondary)
                            
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .frame(height: 20)
                                    .foregroundColor(theme.progressBackground)
                                
                                Capsule()
                                    .frame(width: UIScreen.main.bounds.width * 0.5 * viewModel.progressValue, height: 20)
                                    .foregroundColor(theme.progress)
                            }
                            
                            HStack(spacing: 5) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(theme.failure)
                                    .font(.system(size: 24))
                                Text("\(viewModel.heartsCount)")
                                    .foregroundColor(theme.textPrimary)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Exercise content
                    VStack(spacing: 20) {
                        Text(exercise.promptTitle ?? "Select the correct image")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                            .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            Button {
                                // Action to play sound
                                print("Play sound")
                            } label: {
                                ZStack {
                                    // Bottom layer (shadow)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(theme.accent.opacity(0.7))
                                        .frame(width: 50, height: 50)
                                    
                                    // Top layer (main button)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(theme.accent)
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "speaker.wave.2.fill")
                                            .foregroundColor(theme.textPrimary)
                                            .font(.system(size: 20))
                                    }
                                    .offset(y: -4)
                                }
                            }

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
                        
                        // Check/Continue button
                        VStack(spacing: 16) {
                            if viewModel.isAnswered {
                                HStack {
                                    if viewModel.isCorrect {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(theme.success)
                                            Text("Awesome!")
                                                .foregroundColor(theme.success)
                                                .fontWeight(.bold)
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(theme.failure)
                                            Text("Not quite right")
                                                .foregroundColor(theme.failure)
                                                .fontWeight(.bold)
                                        }
                                    }

                                    Spacer()

                                    HStack(spacing: 15) {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(viewModel.isCorrect ? theme.success : theme.textSecondary)
                                        Image(systemName: "camera")
                                            .foregroundColor(viewModel.isCorrect ? theme.success : theme.textSecondary)
                                    }
                                }
                            }

                            // Button with consistent 3D effect
                            ZStack {
                                // Shadow layer
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.isAnswered ? 
                                         (viewModel.isCorrect ? theme.success.opacity(0.7) : theme.failure.opacity(0.7)) :
                                         (viewModel.selectedImageId == nil ? theme.buttonDisabled.opacity(0.7) : theme.accent.opacity(0.7)))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                
                                Button(action: {
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
                                }) {
                                    Text(viewModel.isAnswered ? "CONTINUE" : "CHECK")
                                        .fontWeight(.bold)
                                        .foregroundColor(viewModel.selectedImageId == nil && !viewModel.isAnswered ? 
                                                       theme.textSecondary : theme.textPrimary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(viewModel.isAnswered ? 
                                                     (viewModel.isCorrect ? theme.success : theme.failure) :
                                                     (viewModel.selectedImageId == nil ? theme.buttonDisabled : theme.accent))
                                        )
                                }
                                .disabled(viewModel.selectedImageId == nil && !viewModel.isAnswered)
                                .offset(y: -4)
                            }
                            .frame(height: 50)
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
                Button(action: {
                    appState.currentLesson = nil
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(theme.accent)
                }
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
                ]
            )
        ]
    )
}
