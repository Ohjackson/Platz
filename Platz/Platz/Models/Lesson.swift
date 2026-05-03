//
//  Lesson.swift
//  Platz
//
//  학습 레슨 모델
//

import Foundation

struct Lesson: Codable, Identifiable {
    let id: String
    let track: LessonTrack
    let title: String
    let level: LessonLevel
    let durationMin: Int
    let contentMarkdown: String
    let examples: [LessonExample]
    let tips: [String]?
    let miniQuizId: String?
    let order: Int                  // 트랙 내 순서
}

enum LessonTrack: String, Codable, CaseIterable {
    case alphabet = "alphabet"
    case numbers = "numbers"
    case grammar = "grammar"
    case conversation = "conversation"
    case quiz = "quiz"

    var displayName: String {
        switch self {
        case .alphabet: return "알파벳"
        case .numbers: return "숫자 1~100"
        case .grammar: return "기초 문법"
        case .conversation: return "회화"
        case .quiz: return "퀴즈"
        }
    }

    var icon: String {
        switch self {
        case .alphabet: return "textformat.abc"
        case .numbers: return "number"
        case .grammar: return "text.book.closed.fill"
        case .conversation: return "bubble.left.and.bubble.right.fill"
        case .quiz: return "questionmark.circle.fill"
        }
    }

    var description: String {
        switch self {
        case .alphabet: return "독일어 발음과 철자 익히기"
        case .numbers: return "숫자 읽기와 조합 규칙"
        case .grammar: return "기초 문법 개념 맛보기"
        case .conversation: return "실생활 대화 연습"
        case .quiz: return "배운 내용 테스트"
        }
    }

    var color: String {
        switch self {
        case .alphabet: return "4ADE80"     // Green
        case .numbers: return "60A5FA"      // Blue
        case .grammar: return "C084FC"      // Purple
        case .conversation: return "FB923C" // Orange
        case .quiz: return "F472B6"         // Pink
        }
    }
}

enum LessonLevel: String, Codable, CaseIterable, Identifiable {
    case a1 = "a1"
    case a2 = "a2"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .a1: return "A1"
        case .a2: return "A2"
        }
    }

    var subtitle: String {
        switch self {
        case .a1: return "기초 독일어"
        case .a2: return "확장 표현"
        }
    }

    var sortOrder: Int {
        switch self {
        case .a1: return 1
        case .a2: return 2
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
        case "a1", "beginner", "intermediate":
            self = .a1
        case "a2", "advanced":
            self = .a2
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unsupported lesson level: \(value)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

struct LessonExample: Codable, Identifiable {
    var id: String { de }
    let de: String
    let ko: String
    let note: String?
    let pronunciation: String?      // 발음 (한글 표기)
}
