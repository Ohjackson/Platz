//
//  Article.swift
//  Platz
//
//  독일 정보 아티클 모델
//

import Foundation

struct Article: Codable, Identifiable {
    let id: String
    let category: ArticleCategory
    let title: String
    let summary: String
    let readTime: Int               // 분
    let sections: [ArticleSection]
    let quickFacts: [QuickFact]
    let relatedIds: [String]
    let tags: [String]
    let updatedAt: String
}

enum ArticleCategory: String, Codable, CaseIterable {
    case general = "general"        // 상식
    case politics = "politics"      // 정치·정당
    case administration = "admin"   // 행정 시스템
    case culture = "culture"        // 문화
    
    var displayName: String {
        switch self {
        case .general: return "상식"
        case .politics: return "정치·정당"
        case .administration: return "행정 시스템"
        case .culture: return "문화"
        }
    }
    
    var icon: String {
        switch self {
        case .general: return "lightbulb.fill"
        case .politics: return "building.columns.fill"
        case .administration: return "doc.text.fill"
        case .culture: return "theatermasks.fill"
        }
    }
    
    var description: String {
        switch self {
        case .general: return "독일의 기본 상식과 정보"
        case .politics: return "정치 구조와 정당 시스템"
        case .administration: return "행정과 공공 서비스"
        case .culture: return "문화, 음식, 생활 방식"
        }
    }
}

struct ArticleSection: Codable, Identifiable {
    var id: String { heading }
    let heading: String
    let bodyMarkdown: String
}

struct QuickFact: Codable, Identifiable {
    var id: String { key }
    let key: String
    let value: String
}
