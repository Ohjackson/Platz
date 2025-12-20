//
//  Dialog.swift
//  Platz
//
//  회화 대화 모델
//

import Foundation

struct Dialog: Codable, Identifiable {
    let id: String
    let topic: String               // 인사, 카페, 길찾기 등
    let title: String
    let description: String?
    let lines: [DialogLine]
    let keywords: [DialogKeyword]
    let quizId: String?
    let order: Int                  // 표시 순서
}

struct DialogLine: Codable, Identifiable {
    var id: String { "\(speaker)-\(de)" }
    let speaker: String             // A, B (또는 이름)
    let de: String                  // 독일어
    let ko: String                  // 한국어 번역
    let note: String?               // 추가 설명
}

struct DialogKeyword: Codable, Identifiable {
    var id: String { word }
    let word: String                // 독일어 단어/표현
    let meaning: String             // 한국어 의미
    let usage: String?              // 사용 예시
}

// MARK: - Dialog Topics
enum DialogTopic: String, CaseIterable {
    case greeting = "greeting"
    case cafe = "cafe"
    case directions = "directions"
    case train = "train"
    case introduction = "introduction"
    case school = "school"
    case hobby = "hobby"
    
    var displayName: String {
        switch self {
        case .greeting: return "인사/소개"
        case .cafe: return "카페 주문"
        case .directions: return "길 묻기"
        case .train: return "기차표 구매"
        case .introduction: return "자기소개"
        case .school: return "학교/수업"
        case .hobby: return "취미"
        }
    }
    
    var icon: String {
        switch self {
        case .greeting: return "hand.wave.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .directions: return "map.fill"
        case .train: return "tram.fill"
        case .introduction: return "person.fill"
        case .school: return "graduationcap.fill"
        case .hobby: return "gamecontroller.fill"
        }
    }
}
