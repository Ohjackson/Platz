//
//  Quiz.swift
//  Platz
//
//  퀴즈 모델
//

import Foundation

struct Quiz: Codable, Identifiable {
    let id: String
    let type: QuizType
    let title: String
    let description: String?
    let questions: [QuizQuestion]
    let sourceDialogId: String?     // 회화 기반 퀴즈인 경우
    let sourceLessonId: String?     // 레슨 기반 퀴즈인 경우
    let passingScore: Int           // 통과 점수 (퍼센트)
}

enum QuizType: String, Codable {
    case lesson = "lesson"          // 레슨 기반
    case dialog = "dialog"          // 회화 기반
    case mcq = "mcq"                // 객관식
    case choice = "choice"          // 객관식 (JSON 호환)
    case fill = "fill"              // 빈칸 채우기
    case order = "order"            // 순서 맞추기
    case matching = "matching"      // 매칭
    
    var displayName: String {
        switch self {
        case .lesson: return "레슨 퀴즈"
        case .dialog: return "회화 퀴즈"
        case .mcq, .choice: return "객관식"
        case .fill: return "빈칸 채우기"
        case .order: return "순서 맞추기"
        case .matching: return "매칭"
        }
    }
}

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let question: String
    let questionType: QuizType?     // 문제별 타입 (nil이면 Quiz 전체 타입 따름)
    let options: [String]?          // MCQ 선택지
    let correctAnswer: String       // 정답
    let explanation: String         // 해설
    let hint: String?               // 힌트
    
    enum CodingKeys: String, CodingKey {
        case id, question, options, correctAnswer, explanation, hint
        case questionType = "type"
    }
}

// MARK: - Quiz Result
struct QuizResult {
    let quizId: String
    let totalQuestions: Int
    let correctAnswers: Int
    let wrongAnswers: [String]      // 틀린 문제 ID들
    let completedAt: Date
    
    var score: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions)) * 100)
    }
    
    var isPassed: Bool {
        return score >= 60
    }
    
    var feedbackMessage: String {
        switch score {
        case 90...100:
            return "훌륭해요! 완벽에 가까운 점수입니다! 🎉"
        case 70..<90:
            return "잘했어요! 조금만 더 연습하면 완벽해질 거예요! 👍"
        case 50..<70:
            return "좋은 시작이에요! 틀린 문제를 다시 복습해보세요. 💪"
        default:
            return "괜찮아요! 다시 도전해보세요. 연습이 실력을 만들어요! 📚"
        }
    }
}
