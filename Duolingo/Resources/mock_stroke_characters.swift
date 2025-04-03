//
//  mock_stroke_characters.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//

import SwiftUI
import Foundation

// Helper function to create mock stroke character data
func createMockStrokeCharacters() -> [StrokeCharacter] {
    [
        // Character: 一 (yī) - one
        StrokeCharacter(
            id: UUID(),
            character: "一",
            pinyin: "yī",
            meaning: "one",
            strokeCount: 1,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 75, y: 150),
                    CGPoint(x: 150, y: 150),
                    CGPoint(x: 225, y: 150)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 二 (èr) - two
        StrokeCharacter(
            id: UUID(),
            character: "二",
            pinyin: "èr",
            meaning: "two",
            strokeCount: 2,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 75, y: 120),
                    CGPoint(x: 150, y: 120),
                    CGPoint(x: 225, y: 120)
                ]),
                StrokePath(points: [
                    CGPoint(x: 75, y: 180),
                    CGPoint(x: 150, y: 180),
                    CGPoint(x: 225, y: 180)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 三 (sān) - three
        StrokeCharacter(
            id: UUID(),
            character: "三",
            pinyin: "sān",
            meaning: "three",
            strokeCount: 3,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 75, y: 100),
                    CGPoint(x: 150, y: 100),
                    CGPoint(x: 225, y: 100)
                ]),
                StrokePath(points: [
                    CGPoint(x: 75, y: 150),
                    CGPoint(x: 150, y: 150),
                    CGPoint(x: 225, y: 150)
                ]),
                StrokePath(points: [
                    CGPoint(x: 75, y: 200),
                    CGPoint(x: 150, y: 200),
                    CGPoint(x: 225, y: 200)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 口 (kǒu) - mouth
        StrokeCharacter(
            id: UUID(),
            character: "口",
            pinyin: "kǒu",
            meaning: "mouth",
            strokeCount: 3,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 100, y: 100),
                    CGPoint(x: 200, y: 100)
                ]),
                StrokePath(points: [
                    CGPoint(x: 200, y: 100),
                    CGPoint(x: 200, y: 200)
                ]),
                StrokePath(points: [
                    CGPoint(x: 200, y: 200),
                    CGPoint(x: 100, y: 200),
                    CGPoint(x: 100, y: 100)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 日 (rì) - sun/day
        StrokeCharacter(
            id: UUID(),
            character: "日",
            pinyin: "rì",
            meaning: "sun/day",
            strokeCount: 4,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 100, y: 100),
                    CGPoint(x: 200, y: 100)
                ]),
                StrokePath(points: [
                    CGPoint(x: 200, y: 100),
                    CGPoint(x: 200, y: 200)
                ]),
                StrokePath(points: [
                    CGPoint(x: 200, y: 200),
                    CGPoint(x: 100, y: 200),
                    CGPoint(x: 100, y: 100)
                ]),
                StrokePath(points: [
                    CGPoint(x: 100, y: 150),
                    CGPoint(x: 200, y: 150)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 木 (mù) - tree/wood
        StrokeCharacter(
            id: UUID(),
            character: "木",
            pinyin: "mù",
            meaning: "tree/wood",
            strokeCount: 4,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 150, y: 80),
                    CGPoint(x: 150, y: 220)
                ]),
                StrokePath(points: [
                    CGPoint(x: 100, y: 140),
                    CGPoint(x: 200, y: 140)
                ]),
                StrokePath(points: [
                    CGPoint(x: 120, y: 180),
                    CGPoint(x: 150, y: 220)
                ]),
                StrokePath(points: [
                    CGPoint(x: 180, y: 180),
                    CGPoint(x: 150, y: 220)
                ])
            ],
            animationSpeed: 1.0
        ),
        
        // Character: 山 (shān) - mountain
        StrokeCharacter(
            id: UUID(),
            character: "山",
            pinyin: "shān",
            meaning: "mountain",
            strokeCount: 3,
            strokeOrder: [
                StrokePath(points: [
                    CGPoint(x: 100, y: 180),
                    CGPoint(x: 100, y: 140),
                    CGPoint(x: 150, y: 100),
                    CGPoint(x: 200, y: 140),
                    CGPoint(x: 200, y: 180)
                ]),
                StrokePath(points: [
                    CGPoint(x: 130, y: 140),
                    CGPoint(x: 130, y: 200)
                ]),
                StrokePath(points: [
                    CGPoint(x: 170, y: 140),
                    CGPoint(x: 170, y: 200)
                ])
            ],
            animationSpeed: 1.2
        )
    ]
}

// Create a mock lesson with stroke drawing exercises
func createStrokeDrawingLesson() -> Lesson {
    let mockCharacters = createMockStrokeCharacters()
    
    // Create exercises for each character
    var exercises: [Exercise] = []
    
    for i in 0..<mockCharacters.count {
        let exercise = Exercise(
            id: UUID(),
            type: .strokeDrawing,
            promptTitle: "Practice drawing this character",
            pinyin: mockCharacters[i].pinyin,
            characters: mockCharacters[i].character,
            correctAnswer: nil,
            availableWords: nil,
            leftItems: nil,
            rightItems: nil,
            rightItemsPinyin: nil,
            imageOptions: nil,
            audioURL: nil,
            strokeCharacters: [mockCharacters[i]]
        )
        exercises.append(exercise)
    }
    
    return Lesson(
        id: UUID(),
        title: "Character Writing",
        icon: "pencil",
        type: .translation, // Using existing lesson type
        requiredXP: 0,
        isLocked: false,
        exercises: exercises
    )
}