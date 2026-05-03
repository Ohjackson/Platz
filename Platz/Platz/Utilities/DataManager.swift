//
//  DataManager.swift
//  Platz
//
//  JSON 데이터 로딩 및 관리
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var quotes: [Quote] = []
    @Published var articles: [Article] = []
    @Published var lessons: [Lesson] = []
    @Published var dialogs: [Dialog] = []
    @Published var quizzes: [Quiz] = []

    @Published var isLoading = false
    @Published var error: String?

    private init() {
        loadAllData()
    }

    // MARK: - Load All Data
    func loadAllData() {
        isLoading = true

        quotes = load("quotes", as: [Quote].self) ?? []
        articles = load("articles", as: [Article].self) ?? []
        lessons = load("lessons", as: [Lesson].self) ?? []
        dialogs = load("dialogs", as: [Dialog].self) ?? []
        quizzes = load("quizzes", as: [Quiz].self) ?? []

        isLoading = false
    }

    // MARK: - Generic JSON Loader
    private func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("❌ Could not find \(filename).json")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Error loading \(filename).json: \(error)")
            self.error = "데이터 로드 실패: \(filename)"
            return nil
        }
    }

    // MARK: - Quote Helpers
    var todayQuote: Quote? {
        Quote.todayQuote(from: quotes)
    }

    func quote(byId id: String) -> Quote? {
        quotes.first { $0.id == id }
    }

    // MARK: - Article Helpers
    func articles(forCategory category: ArticleCategory) -> [Article] {
        articles.filter { $0.category == category }
    }

    func article(byId id: String) -> Article? {
        articles.first { $0.id == id }
    }

    func relatedArticles(for article: Article) -> [Article] {
        article.relatedIds.compactMap { id in
            articles.first { $0.id == id }
        }
    }

    var recommendedArticle: Article? {
        // 간단한 추천 로직: 오늘 날짜 기반으로 하나 선택
        guard !articles.isEmpty else { return nil }
        let calendar = Calendar.current
        let today = Date()
        let day = calendar.component(.day, from: today)
        let index = day % articles.count
        return articles[index]
    }

    // MARK: - Lesson Helpers
    func lessons(forTrack track: LessonTrack, level: LessonLevel? = nil) -> [Lesson] {
        lessons
            .filter { lesson in
                lesson.track == track && (level == nil || lesson.level == level)
            }
            .sorted(by: sortLessons)
    }

    func lessons(forLevel level: LessonLevel) -> [Lesson] {
        lessons
            .filter { $0.level == level }
            .sorted(by: sortLessons)
    }

    func lesson(byId id: String) -> Lesson? {
        lessons.first { $0.id == id }
    }

    func lessonsCount(forTrack track: LessonTrack, level: LessonLevel? = nil) -> Int {
        lessons(forTrack: track, level: level).count
    }

    // MARK: - Dialog Helpers
    func dialogs(forTopic topic: String, level: LessonLevel? = nil) -> [Dialog] {
        dialogs
            .filter { dialog in
                dialog.topic == topic && (level == nil || dialog.level == level)
            }
            .sorted(by: sortDialogs)
    }

    func dialog(byId id: String) -> Dialog? {
        dialogs.first { $0.id == id }
    }

    var allDialogs: [Dialog] {
        dialogs.sorted(by: sortDialogs)
    }

    func allDialogs(for level: LessonLevel) -> [Dialog] {
        dialogs
            .filter { $0.level == level }
            .sorted(by: sortDialogs)
    }

    // MARK: - Quiz Helpers
    func quiz(byId id: String) -> Quiz? {
        quizzes.first { $0.id == id }
    }

    func quiz(forLessonId lessonId: String) -> Quiz? {
        quizzes.first { $0.sourceLessonId == lessonId }
    }

    func quiz(forDialogId dialogId: String) -> Quiz? {
        quizzes.first { $0.sourceDialogId == dialogId }
    }

    // MARK: - Search
    func searchArticles(query: String) -> [Article] {
        guard !query.isEmpty else { return articles }
        let lowercased = query.lowercased()
        return articles.filter {
            $0.title.lowercased().contains(lowercased) ||
            $0.summary.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }

    private func sortLessons(_ lhs: Lesson, _ rhs: Lesson) -> Bool {
        if lhs.level != rhs.level {
            return lhs.level.sortOrder < rhs.level.sortOrder
        }

        if lhs.track != rhs.track {
            return lhs.track.rawValue < rhs.track.rawValue
        }

        return lhs.order < rhs.order
    }

    private func sortDialogs(_ lhs: Dialog, _ rhs: Dialog) -> Bool {
        if lhs.level != rhs.level {
            return lhs.level.sortOrder < rhs.level.sortOrder
        }

        return lhs.order < rhs.order
    }
}
