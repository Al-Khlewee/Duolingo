//
//  Exercise.swift
//  Duolingo
//
//  Created by Hatem Al-Khlewee on 25/03/2025.
//


// Models/Exercise.swift
import Foundation

struct Exercise: Codable, Identifiable {
    let id: UUID
    let type: ExerciseType
    let promptTitle: String? // Optional properties for different exercise types.
    let pinyin: String?
    let characters: String?
    let correctAnswer: [String]?
    var availableWords: [String]?
    let leftItems: [String]?
    let rightItems: [String]?
    let rightItemsPinyin: [String]?
    let imageOptions: [ImageOption]? // New property for image selection exercise
    let audioURL: String? // URL string for audio file 
    let strokeCharacters: [StrokeCharacter]? // New property for stroke drawing exercises

    //  RawRepresentable for JSON (de)serialization and easy debugging.
    enum ExerciseType: String, Codable, CaseIterable {
        case translation
        case matching
        case imageSelection 
        case listening // New exercise type for listening exercises
        case strokeDrawing // New exercise type for Chinese character stroke drawing
    }
}

// New struct for image options
struct ImageOption: Codable, Identifiable {
    let id: UUID
    let systemImageName: String // Using system images for now
    let isCorrect: Bool
    let englishText: String
}

// New struct for Chinese character strokes
struct StrokeCharacter: Codable, Identifiable {
    let id: UUID
    let character: String
    let pinyin: String
    let meaning: String
    let strokeCount: Int
    let strokeOrder: [StrokePath]
    let animationSpeed: Double // Speed of the animation in seconds
}

// Represents a single stroke path in a character
struct StrokePath: Codable, Identifiable {
    let id: UUID
    let points: [CGPoint]
    let strokeWidth: CGFloat
    
    // Coding keys to handle CGPoint encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id
        case points
        case strokeWidth
    }
    
    init(id: UUID = UUID(), points: [CGPoint], strokeWidth: CGFloat = 8) {
        self.id = id
        self.points = points
        self.strokeWidth = strokeWidth
    }
    
    // Custom decoding for CGPoint
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        strokeWidth = try container.decode(CGFloat.self, forKey: .strokeWidth)
        
        // Decode points as array of dictionaries with x, y values
        let pointsData = try container.decode([[String: CGFloat]].self, forKey: .points)
        points = pointsData.map { dict in
            CGPoint(x: dict["x"] ?? 0, y: dict["y"] ?? 0)
        }
    }
    
    // Custom encoding for CGPoint
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(strokeWidth, forKey: .strokeWidth)
        
        // Encode points as array of dictionaries with x, y values
        let pointsData = points.map { point in
            ["x": point.x, "y": point.y]
        }
        try container.encode(pointsData, forKey: .points)
    }
}

// Extension to support CGPoint in StrokePath
extension CGPoint: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y])
    }
    
    public init(from decoder: Decoder) throws {
        var array = try decoder.singleValueContainer().decode([Double].self)
        self.init(x: array[0], y: array[1])
    }
}