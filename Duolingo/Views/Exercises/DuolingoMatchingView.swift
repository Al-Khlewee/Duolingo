//
//  DuolingoMatchingView.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Views/Exercises/DuolingoMatchingView.swift
import SwiftUI

struct DuolingoMatchingView: View {
    @StateObject private var viewModel: MatchingExerciseViewModel
    @EnvironmentObject var appState: ChineseAppState
    @Environment(\.theme) var theme // Access the theme

    init(lesson: Lesson) {
        _viewModel = StateObject(wrappedValue: MatchingExerciseViewModel(lesson: lesson, exerciseIndex: 0))
    }
    
    var body: some View {
           ZStack {
               theme.background.ignoresSafeArea() // Set background

               VStack(spacing: 0) {
                   // Header - Progress Bar and Hearts
                   HStack {
                       Image(systemName: "gearshape")
                           .font(.system(size: 24))
                           .foregroundColor(theme.textSecondary)

                       ZStack(alignment: .leading) {
                           Capsule()
                               .frame(height: 20)
                               .foregroundColor(theme.progressBackground)

                           Capsule()
                               .frame(width: UIScreen.main.bounds.width * 0.6 * viewModel.progress, height: 20) // Dynamic width
                               .foregroundColor(theme.progress)
                       }

                       HStack(spacing: 5) {
                           Image(systemName: "heart.fill")
                               .foregroundColor(theme.failure)
                               .font(.system(size: 24))
                           Text("\(viewModel.hearts)")
                               .foregroundColor(theme.textPrimary)
                               .bold()
                       }
                   }
                   .padding(.horizontal, 20)
                   .padding(.vertical, 10)

                   Text("Tap the matching pairs") // Instructions
                       .font(.title2)
                       .foregroundColor(theme.textPrimary) // Theme color
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.horizontal)
                       .padding(.top, 15)
                       .padding(.bottom, 30)

                   Spacer()
                   // Matching Cards
                   HStack(spacing: 20) {
                       VStack(spacing: 15) {
                           ForEach(viewModel.leftItems.indices, id: \.self) { index in
                               MatchCardView(
                                   text: viewModel.leftItems[index],
                                   pinyin: nil, // Left items don't have pinyin
                                   isLeft: true,
                                   isSelected: viewModel.selectedCards.contains(.left(index)),
                                   isMatched: viewModel.matchedPairs.contains(index),
                                   action: { viewModel.selectCard(.left(index)) } // Select left card
                               )
                           }
                       }
                       VStack(spacing: 15) {
                           ForEach(viewModel.rightItems.indices, id: \.self) { index in
                               //  use the shuffled indices to display right items
                               if viewModel.rightIndices.indices.contains(index) {
                                   MatchCardView(
                                       text: viewModel.rightItems[viewModel.rightIndices[index]],
                                       pinyin: viewModel.rightItemsPinyin[viewModel.rightIndices[index]], //  get pinyin using the shuffled index
                                       isLeft: false,
                                       isSelected: viewModel.selectedCards.contains(.right(index)),
                                       isMatched: viewModel.matchedPairs.contains(viewModel.rightIndices[index]), // Check match using original index
                                       action: { viewModel.selectCard(.right(index)) } // Select right card
                                   )
                               }
                           }
                       }
                   }
                   .padding(.horizontal)

                   Spacer()

                   // CONTINUE button with consistent 3D effect
                   ZStack {
                       // Shadow layer
                       RoundedRectangle(cornerRadius: 12)
                           .fill((viewModel.matchedPairs.count == viewModel.leftItems.count ? theme.success : theme.buttonDisabled).opacity(0.7))
                           .frame(maxWidth: .infinity)
                           .frame(height: 50)

                       // Button layer
                       Button {
                           if viewModel.matchedPairs.count == viewModel.leftItems.count { // Check if all pairs are matched
                               appState.completeCurrentExercise()  // Complete the exercise
                               //  load next exercise if still in the same lesson
                               if appState.currentLesson != nil {
                                   viewModel.loadExercise(at: appState.currentExerciseIndex)
                               }
                           }
                       } label: {
                           Text("CONTINUE")
                               .fontWeight(.bold)
                               .foregroundColor(viewModel.matchedPairs.count == viewModel.leftItems.count ? theme.textPrimary : theme.textSecondary)
                               .frame(maxWidth: .infinity)
                               .frame(height: 50)
                               .background(
                                   RoundedRectangle(cornerRadius: 12)
                                       .fill(viewModel.matchedPairs.count == viewModel.leftItems.count ? theme.success : theme.buttonDisabled) // Change color based on match completion
                               )
                       }
                       .disabled(viewModel.matchedPairs.count != viewModel.leftItems.count) // Disable until all pairs are matched
                       .offset(y: -4)  // 3D Effect
                   }
                   .frame(height: 50)
                   .padding(.horizontal)
                   .padding(.bottom, 40)
               }
           }
           .navigationBarBackButtonHidden(true) // Custom back button
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   // Back Button - Extracted for consistency.
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
               appState.isInExerciseView = true  // Hide bottom nav when view appears
           }
           .onDisappear {
               appState.isInExerciseView = false  // Show bottom nav when view disappears
           }
       }
}