//
//  Progress.swift
//  Platz
//
//  진행도 관리
//

import Foundation
import SwiftUI
import Combine

// MARK: - Progress Manager
class ProgressManager: ObservableObject {
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let completedLessons = "completedLessonIds"
        static let quizStats = "quizStats"
        static let streak = "streak"
        static let lastStudyDate = "lastStudyDate"
        static let bookmarkedArticles = "bookmarkedArticleIds"
        static let bookmarkedLessons = "bookmarkedLessonIds"
        static let recentArticles = "recentArticleIds"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastLessonId = "lastLessonId"
        static let totalStudyMinutes = "totalStudyMinutes"
    }
    
    // MARK: - Published Properties
    @Published var completedLessonIds: Set<String> {
        didSet { save(Array(completedLessonIds), forKey: Keys.completedLessons) }
    }
    
    @Published var quizStats: [String: QuizStat] {
        didSet { saveQuizStats() }
    }
    
    @Published var streak: Int {
        didSet { defaults.set(streak, forKey: Keys.streak) }
    }
    
    @Published var lastStudyDate: Date? {
        didSet {
            if let date = lastStudyDate {
                defaults.set(date.timeIntervalSince1970, forKey: Keys.lastStudyDate)
            }
        }
    }
    
    @Published var bookmarkedArticleIds: Set<String> {
        didSet { save(Array(bookmarkedArticleIds), forKey: Keys.bookmarkedArticles) }
    }
    
    @Published var bookmarkedLessonIds: Set<String> {
        didSet { save(Array(bookmarkedLessonIds), forKey: Keys.bookmarkedLessons) }
    }
    
    @Published var recentArticleIds: [String] {
        didSet { save(recentArticleIds, forKey: Keys.recentArticles) }
    }
    
    @Published var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }
    
    @Published var lastLessonId: String? {
        didSet { defaults.set(lastLessonId, forKey: Keys.lastLessonId) }
    }
    
    @Published var totalStudyMinutes: Int {
        didSet { defaults.set(totalStudyMinutes, forKey: Keys.totalStudyMinutes) }
    }
    
    // MARK: - Initialization
    init() {
        self.completedLessonIds = Set(defaults.stringArray(forKey: Keys.completedLessons) ?? [])
        self.quizStats = Self.loadQuizStats(from: defaults)
        self.streak = defaults.integer(forKey: Keys.streak)
        
        if let timestamp = defaults.object(forKey: Keys.lastStudyDate) as? TimeInterval {
            self.lastStudyDate = Date(timeIntervalSince1970: timestamp)
        } else {
            self.lastStudyDate = nil
        }
        
        self.bookmarkedArticleIds = Set(defaults.stringArray(forKey: Keys.bookmarkedArticles) ?? [])
        self.bookmarkedLessonIds = Set(defaults.stringArray(forKey: Keys.bookmarkedLessons) ?? [])
        self.recentArticleIds = defaults.stringArray(forKey: Keys.recentArticles) ?? []
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
        self.lastLessonId = defaults.string(forKey: Keys.lastLessonId)
        self.totalStudyMinutes = defaults.integer(forKey: Keys.totalStudyMinutes)
        
        updateStreak()
    }
    
    // MARK: - Lesson Progress
    func completeLesson(_ lessonId: String, duration: Int = 0) {
        completedLessonIds.insert(lessonId)
        lastLessonId = lessonId
        totalStudyMinutes += duration
        recordStudyToday()
    }
    
    func isLessonCompleted(_ lessonId: String) -> Bool {
        completedLessonIds.contains(lessonId)
    }
    
    // MARK: - Quiz Stats
    func recordQuizResult(_ result: QuizResult) {
        var stat = quizStats[result.quizId] ?? QuizStat(bestScore: 0, lastScore: 0, attempts: 0)
        stat.lastScore = result.score
        stat.bestScore = max(stat.bestScore, result.score)
        stat.attempts += 1
        quizStats[result.quizId] = stat
        recordStudyToday()
    }
    
    // MARK: - Bookmarks
    func toggleArticleBookmark(_ articleId: String) {
        if bookmarkedArticleIds.contains(articleId) {
            bookmarkedArticleIds.remove(articleId)
        } else {
            bookmarkedArticleIds.insert(articleId)
        }
    }
    
    func isArticleBookmarked(_ articleId: String) -> Bool {
        bookmarkedArticleIds.contains(articleId)
    }
    
    func toggleLessonBookmark(_ lessonId: String) {
        if bookmarkedLessonIds.contains(lessonId) {
            bookmarkedLessonIds.remove(lessonId)
        } else {
            bookmarkedLessonIds.insert(lessonId)
        }
    }
    
    // MARK: - Recent Articles
    func addRecentArticle(_ articleId: String) {
        var recent = recentArticleIds.filter { $0 != articleId }
        recent.insert(articleId, at: 0)
        recentArticleIds = Array(recent.prefix(10))
    }
    
    // MARK: - Streak
    private func recordStudyToday() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastStudyDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            let daysDiff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysDiff == 1 {
                // 연속 학습
                streak += 1
            } else if daysDiff > 1 {
                // 연속 학습 끊김
                streak = 1
            }
            // daysDiff == 0이면 오늘 이미 학습함, streak 유지
        } else {
            streak = 1
        }
        
        lastStudyDate = Date()
    }
    
    private func updateStreak() {
        guard let lastDate = lastStudyDate else { return }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastDay = Calendar.current.startOfDay(for: lastDate)
        let daysDiff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        if daysDiff > 1 {
            streak = 0
        }
    }
    
    // MARK: - Reset
    func resetProgress() {
        completedLessonIds = []
        quizStats = [:]
        streak = 0
        lastStudyDate = nil
        lastLessonId = nil
        totalStudyMinutes = 0
        // Note: bookmarks와 recentArticles는 유지
    }
    
    func resetAll() {
        resetProgress()
        bookmarkedArticleIds = []
        bookmarkedLessonIds = []
        recentArticleIds = []
        hasCompletedOnboarding = false
    }
    
    // MARK: - Helpers
    private func save(_ array: [String], forKey key: String) {
        defaults.set(array, forKey: key)
    }
    
    private func saveQuizStats() {
        if let data = try? JSONEncoder().encode(quizStats) {
            defaults.set(data, forKey: Keys.quizStats)
        }
    }
    
    private static func loadQuizStats(from defaults: UserDefaults) -> [String: QuizStat] {
        guard let data = defaults.data(forKey: Keys.quizStats),
              let stats = try? JSONDecoder().decode([String: QuizStat].self, from: data) else {
            return [:]
        }
        return stats
    }
}

// MARK: - Quiz Stat
struct QuizStat: Codable {
    var bestScore: Int
    var lastScore: Int
    var attempts: Int
}

// MARK: - Progress Summary
extension ProgressManager {
    var completedLessonsCount: Int {
        completedLessonIds.count
    }
    
    var thisWeekStudyMinutes: Int {
        // 간단한 구현 - 실제로는 더 정교한 추적 필요
        totalStudyMinutes
    }
}
