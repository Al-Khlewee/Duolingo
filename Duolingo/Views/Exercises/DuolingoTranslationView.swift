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
                    headerView  // Reusable header view.
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(exercise.promptTitle ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary) // Use theme color
                            .padding(.top, 20)
                        
                        HStack(alignment: .top, spacing: 15) {
                            speakerButton // Reusable speaker button
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(exercise.pinyin ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textSecondary) // Theme color
                                Text(exercise.characters ?? "")
                                    .font(.title3)
                                    .foregroundColor(theme.textPrimary)
                                
                                //  visual line using dots.
                                HStack(spacing: 2) {
                                    ForEach(0..<40, id: \.self) { _ in
                                        Circle()
                                            .frame(width: 3, height: 3)
                                            .foregroundColor(theme.textSecondary.opacity(0.5)) // Theme color
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
                                
                                selectedWordsView(correctAnswer: exercise.correctAnswer ?? []) // Reusable view for selected words
                                    .padding(.horizontal, 4)
                            }
                            // View for available word choices.
                            availableWordsView(availableWords: exercise.availableWords ?? [])
                        }
                        .padding(.top, 1)
                        
                        Spacer()
                        
                        answerFeedbackView // View for showing feedback after answering
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Text("Loading...") //  show a loading state.
                    .foregroundColor(theme.textPrimary) // Use theme
            }
        }
        .navigationBarBackButtonHidden(true) // Custom back button for better control
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton // Use a custom back button
            }
        }
        .onAppear {
            appState.isInExerciseView = true  // Hide bottom nav when view appears
        }
        .onDisappear {
            appState.isInExerciseView = false  // Show bottom nav when view disappears
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            Text("\(viewModel.streakCount) IN A ROW")
                .foregroundColor(theme.accent)
                .font(.caption)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .foregroundColor(theme.textSecondary)
                
                // Progress Bar - Using Capsules for a smoother look
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
    }
    // Extracted for reusability and clarity.
    private var backButton: some View {
        Button(action: {
            appState.currentLesson = nil // Go back to the lesson list.
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .foregroundColor(theme.accent)
        }
    }

    private var speakerButton: some View {
        Button(action: {
            viewModel.playAudio() // Trigger audio playback.
        }) {
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
                    Image(systemName: viewModel.isPlaying ? "speaker.wave.3.fill" : "speaker.wave.2.fill") // Dynamic icon
                        .foregroundColor(theme.textPrimary)
                        .font(.system(size: 20))
                }
                .offset(y: -4)
            }
        }
    }


    private func selectedWordsView(correctAnswer: [String]) -> some View {
           FlowLayout(spacing: 10, lineSpacing: 60) {
               if viewModel.isAnswered && viewModel.isCorrect {
                   // Show correct answer
                   ForEach(correctAnswer, id: \.self) { word in
                       wordPill(word: word, isSelected: true)  //  treat correct words as "selected"
                   }
               } else {
                   ForEach(viewModel.selectedWords, id: \.self) { word in
                       wordPill(word: word, isSelected: true)
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
                                // Highlight incorrect words after answering.
                                let isIncorrect = viewModel.isAnswered && !viewModel.isCorrect && !getCorrectAnswer().contains(word)
                                wordPill(word: word, isSelected: false, isHighlighted: isIncorrect)
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
                                wordPill(word: word, isSelected: false, isHighlighted: isIncorrect)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: geometry.size.width, alignment: .center) // Center
            }
            .frame(maxWidth: .infinity) // Ensure it takes up all available space
            .padding(.horizontal, 10) // Add some padding
        }

    private func getCorrectAnswer() -> [String] {
        viewModel.currentExercise?.correctAnswer ?? []
    }
    
    @ViewBuilder //  ViewBuilder to handle different states cleanly
      private var answerFeedbackView: some View {
          if viewModel.isAnswered {
              VStack(spacing: 16) {
                  HStack {
                      if viewModel.isCorrect {
                          HStack {
                              Image(systemName: "checkmark.circle.fill")
                                  .foregroundColor(theme.success) // Theme color
                              Text("Awesome!")
                                  .foregroundColor(theme.success)
                                  .fontWeight(.bold)
                          }
                      } else {
                          HStack {
                              Image(systemName: "xmark.circle.fill")
                                  .foregroundColor(theme.failure) // Theme color
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

                  // Continue Button with consistent 3D effect
                  ZStack {
                      // Shadow layer
                      RoundedRectangle(cornerRadius: 12)
                          .fill(viewModel.isCorrect ? theme.success.opacity(0.7) : theme.buttonDisabled.opacity(0.7))
                          .frame(maxWidth: .infinity)
                          .frame(height: 50)
                      
                      // Button layer
                      Button(action: {
                          if viewModel.isCorrect {
                              appState.completeCurrentExercise()
                              if appState.currentLesson != nil {
                                  viewModel.loadExercise(at: appState.currentExerciseIndex)
                              }
                          }
                          viewModel.resetExercise()
                      }) {
                          Text("CONTINUE")
                              .fontWeight(.bold)
                              .foregroundColor(theme.textPrimary)
                              .frame(maxWidth: .infinity)
                              .frame(height: 50)
                              .background(
                                  RoundedRectangle(cornerRadius: 12)
                                      .fill(viewModel.isCorrect ? theme.success : theme.buttonDisabled)
                              )
                      }
                      .offset(y: -4)
                  }
                  .frame(height: 50)
              }
          } else {
              // Check Button with consistent 3D effect
              ZStack {
                  // Shadow layer
                  RoundedRectangle(cornerRadius: 12)
                      .fill(viewModel.selectedWords.isEmpty ? theme.buttonDisabled.opacity(0.7) : theme.accent.opacity(0.7))
                      .frame(maxWidth: .infinity)
                      .frame(height: 50)

                  // Button layer
                  Button(action: {
                      viewModel.checkAnswer() // Check the answer
                  }) {
                      Text("CHECK")
                          .fontWeight(.bold)
                          .foregroundColor(viewModel.selectedWords.isEmpty ? theme.textPrimary.opacity(0.6) : theme.textPrimary)
                          .frame(maxWidth: .infinity)
                          .frame(height: 50)
                          .background(
                              RoundedRectangle(cornerRadius: 12)
                                  .fill(viewModel.selectedWords.isEmpty ? theme.buttonDisabled : theme.accent)
                          )
                  }
                  .disabled(viewModel.selectedWords.isEmpty) // Disable when no words are selected
                  .offset(y: -4)
              }
              .frame(height: 50)
          }
      }

    //  word pill with consistent styling.
    private func wordPill(word: String, isSelected: Bool, isHighlighted: Bool = false) -> some View {
        Button(action: {
            guard !viewModel.isAnswered else { return } // Disable interaction after answering
            if viewModel.selectedWords.contains(word) {
                viewModel.selectedWords.removeAll { $0 == word } // Deselect
            } else {
                viewModel.selectedWords.append(word) // Select
            }
        }) {
            Text(word)
                .foregroundColor(theme.textPrimary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 12)
                .frame(height: 40)
                .background(
                    ZStack {
                        // Shadow layer (bottom) with offset for 3D effect
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.2))
                            .offset(y: 4)
                        // Main content layer with stroke
                        RoundedRectangle(cornerRadius: 5)
                            .fill(theme.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                )

        }
        .disabled(viewModel.isAnswered) // Disable button after answer is submitted.
    }

    //  determine the background color of a word pill.
    private func backgroundColor(for word: String, isSelected: Bool, isHighlighted: Bool) -> Color {
        if viewModel.isAnswered {
            if viewModel.isCorrect {
                return isSelected ? theme.success : theme.button // Correct answer
            } else {
                // Incorrect answer: Highlight selected incorrect words, and highlight unselected incorrect words.
                if isSelected && !getCorrectAnswer().contains(word) {
                    return theme.failure // Selected, but incorrect
                } else if isHighlighted {
                    return theme.failure.opacity(0.3)  // Highlight incorrect, unselected words.
                } else {
                    return theme.button // Regular, unselected word
                }
            }
        } else {
            // Before answering:  Highlight selected words.
            return isSelected ? theme.highlight : theme.button
        }
    }
}



