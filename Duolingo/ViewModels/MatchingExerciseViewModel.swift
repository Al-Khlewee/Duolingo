//
//  MatchingExerciseViewModel.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// ViewModels/MatchingExerciseViewModel.swift
import Combine
import SwiftUI

class MatchingExerciseViewModel: ObservableObject {
    @Published var leftItems: [String]
    @Published var rightItems: [String]
    @Published var rightItemsPinyin: [String]
    @Published var rightIndices: [Int] //  store shuffled indices for right items
    @Published var progress: CGFloat = 0.0
    @Published var hearts: Int = 5
    @Published var matchedPairs: Set<Int> = []  // Track matched pairs by index
    @Published var selectedCards: Set<SelectedCard> = [] // Track currently selected cards
    @Published var lesson: Lesson

    init(lesson: Lesson, exerciseIndex: Int) {
        self.lesson = lesson
        self.leftItems = []
        self.rightItems = []
        self.rightItemsPinyin = []
        self.rightIndices = []
        loadExercise(at: exerciseIndex) // Load the initial exercise
    }

    func loadExercise(at index: Int) {
        guard index < lesson.exercises.count else {
            print("Exercise index out of bounds")
            return
        }

        let exercise = lesson.exercises[index]
        guard exercise.type == .matching else {
            print("Incorrect exercise type for DuolingoMatchingView")
            return
        }

        self.leftItems = exercise.leftItems ?? []
        self.rightItems = exercise.rightItems ?? []
        self.rightItemsPinyin = exercise.rightItemsPinyin ?? []
        // Shuffle only the indices, not the items themselves. This preserves the mapping.
        self.rightIndices = Array(0..<self.leftItems.count).shuffled()
    }

    //  select a card and manage the selection state.
    func selectCard(_ card: SelectedCard) {
        withAnimation {
            switch card {
            case .left(let index):
                //  deselect any previously selected left card.
                if let existing = selectedCards.first(where: { if case .left(_) = $0 { return true } else { return false } }) {
                    selectedCards.remove(existing)
                }
                selectedCards.insert(.left(index)) // Select the new card.
            case .right(let index):
                //  deselect any previously selected right card.
                if let existing = selectedCards.first(where: { if case .right(_) = $0 { return true } else { return false } }) {
                    selectedCards.remove(existing)
                }
                selectedCards.insert(.right(index)) // Select the new card.
            }

            // If two cards are selected, check for a match.
            if selectedCards.count == 2 {
                checkMatch()
            }
        }
    }


    // Checks if the selected cards are a matching pair.
    private func checkMatch() {
        let cardsArray = Array(selectedCards) // Convert set to array for easier access
        let card1 = cardsArray[0]
        let card2 = cardsArray[1]

        let pairIndex1 = getPairIndex(card1) // Get the original index of the first card
        let pairIndex2 = getPairIndex(card2) // Get the original index of the second card

        if pairIndex1 == pairIndex2 { // If indices match, it's a correct pair
            matchedPairs.insert(pairIndex1) // Add to matched pairs
            progress = CGFloat(matchedPairs.count) / CGFloat(leftItems.count) // Update progress
            selectedCards.removeAll() // Clear selections
        } else {
            // Incorrect match:  deselect after a short delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    self.selectedCards.removeAll()
                }
            }
            hearts = max(hearts - 1, 0) // Decrement hearts
        }
    }

    //  get the original index of a selected card.
    private func getPairIndex(_ card: SelectedCard) -> Int {
        switch card {
        case .left(let i):
            return i // Left card index is its original index
        case .right(let i):
            return rightIndices[i] // Right card index needs to be looked up in the shuffled indices
        }
    }

    // Checks if a card has already been matched.
    func isCardMatched(_ card: SelectedCard) -> Bool {
        switch card {
        case .left(let i):
            return matchedPairs.contains(i) // Check if the original index is in matchedPairs
        case .right(let i):
            return matchedPairs.contains(rightIndices[i]) // Check if the original index (mapped by rightIndices) is in matchedPairs
        }
    }
}

//  represent the selected card state.
enum SelectedCard: Hashable {
    case left(Int)
    case right(Int)
}