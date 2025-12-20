//
//  Quote.swift
//  Platz
//
//  명언 데이터 모델
//

import Foundation

struct Quote: Codable, Identifiable {
    let id: String
    let de: String              // 독일어 원문
    let ko: String              // 한국어 번역
    let author: String?         // 저자 (optional)
    let tags: [String]          // 태그
    let explain: String         // 해설
    let level: String?          // 난이도
    
    // 단어 분석 (간단한 형태)
    var words: [QuoteWord]? {
        return nil // JSON에서 직접 파싱할 수도 있음
    }
}

struct QuoteWord: Codable {
    let word: String
    let meaning: String
    let grammar: String?
}

// MARK: - Quote of the Day Logic
extension Quote {
    /// 오늘의 명언 인덱스 계산 (서버 없이 날짜 기반)
    static func todayIndex(from quotes: [Quote]) -> Int {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let dateInt = year * 10000 + month * 100 + day
        return dateInt % max(quotes.count, 1)
    }
    
    /// 오늘의 명언 가져오기
    static func todayQuote(from quotes: [Quote]) -> Quote? {
        guard !quotes.isEmpty else { return nil }
        let index = todayIndex(from: quotes)
        return quotes[index]
    }
}
