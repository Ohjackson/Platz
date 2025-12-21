//
//  QuizView.swift
//  Platz
//
//  퀴즈 진행 화면
//

import SwiftUI

struct QuizView: View {
    let quiz: Quiz
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    
    @State private var currentIndex = 0
    @State private var selectedAnswer: String?
    @State private var showFeedback = false
    @State private var correctCount = 0
    @State private var wrongIds: [String] = []
    @State private var isCompleted = false
    
    var currentQuestion: QuizQuestion? {
        guard currentIndex < quiz.questions.count else { return nil }
        return quiz.questions[currentIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background.ignoresSafeArea()
                
                if isCompleted {
                    QuizResultContent(
                        quiz: quiz,
                        correctCount: correctCount,
                        totalCount: quiz.questions.count,
                        onRetry: resetQuiz,
                        onDismiss: { dismiss() }
                    )
                } else if let question = currentQuestion {
                    QuizQuestionContent(
                        question: question,
                        questionNumber: currentIndex + 1,
                        totalQuestions: quiz.questions.count,
                        selectedAnswer: $selectedAnswer,
                        showFeedback: showFeedback,
                        onSubmit: submitAnswer,
                        onNext: nextQuestion
                    )
                }
            }
            .navigationTitle(quiz.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .foregroundColor(PlatzColors.primary)
                }
            }
        }
    }
    
    private func submitAnswer() {
        guard let question = currentQuestion, let answer = selectedAnswer else { return }
        showFeedback = true
        if answer == question.correctAnswer {
            correctCount += 1
        } else {
            wrongIds.append(question.id)
        }
    }
    
    private func nextQuestion() {
        if currentIndex < quiz.questions.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
            showFeedback = false
        } else {
            let result = QuizResult(
                quizId: quiz.id,
                totalQuestions: quiz.questions.count,
                correctAnswers: correctCount,
                wrongAnswers: wrongIds,
                completedAt: Date()
            )
            progressManager.recordQuizResult(result)
            isCompleted = true
        }
    }
    
    private func resetQuiz() {
        currentIndex = 0
        selectedAnswer = nil
        showFeedback = false
        correctCount = 0
        wrongIds = []
        isCompleted = false
    }
}

// MARK: - Quiz Question Content
struct QuizQuestionContent: View {
    let question: QuizQuestion
    let questionNumber: Int
    let totalQuestions: Int
    @Binding var selectedAnswer: String?
    let showFeedback: Bool
    let onSubmit: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: PlatzSpacing.lg) {
            // Progress
            HStack {
                Text("\(questionNumber) / \(totalQuestions)")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.textMuted)
                Spacer()
            }
            
            ProgressView(value: Double(questionNumber), total: Double(totalQuestions))
                .tint(PlatzColors.primary)
            
            // Question
            Text(question.question)
                .font(PlatzTypography.title3)
                .foregroundColor(PlatzColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(PlatzSpacing.md)
                .background(PlatzColors.surface)
                .cornerRadius(PlatzRadius.medium)
            
            // Options
            if question.type == .ox, let options = question.options {
                // OX Quiz Layout (Horizontal)
                HStack(spacing: PlatzSpacing.md) {
                    ForEach(options, id: \.self) { option in
                         Button(action: {
                             if !showFeedback { selectedAnswer = option }
                         }) {
                             VStack {
                                 Text(option)
                                     .font(.system(size: 40, weight: .bold))
                                     .foregroundColor(selectedAnswer == option ? .white : PlatzColors.textPrimary)
                             }
                             .frame(maxWidth: .infinity, maxHeight: 120)
                             .background(
                                 // Logic for background color
                                 showFeedback
                                 ? (option == question.correctAnswer ? PlatzColors.success : (selectedAnswer == option && option != question.correctAnswer ? PlatzColors.error : PlatzColors.surface))
                                 : (selectedAnswer == option ? PlatzColors.primary : PlatzColors.surface)
                             )
                             .cornerRadius(PlatzRadius.large)
                             .overlay(
                                 RoundedRectangle(cornerRadius: PlatzRadius.large)
                                    .stroke(
                                        showFeedback
                                        ? (option == question.correctAnswer ? PlatzColors.success : (selectedAnswer == option ? PlatzColors.error : PlatzColors.border))
                                        : (selectedAnswer == option ? PlatzColors.primary : PlatzColors.border),
                                        lineWidth: 2
                                    )
                             )
                         }
                         .buttonStyle(.plain)
                    }
                }
            } else if let options = question.options {
                VStack(spacing: PlatzSpacing.sm) {
                    ForEach(options, id: \.self) { option in
                        OptionButton(
                            text: option,
                            isSelected: selectedAnswer == option,
                            isCorrect: showFeedback ? option == question.correctAnswer : nil,
                            isWrong: showFeedback ? (selectedAnswer == option && option != question.correctAnswer) : false
                        ) {
                            if !showFeedback { selectedAnswer = option }
                        }
                    }
                }
            }
            
            // Feedback
            if showFeedback {
                VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
                    HStack {
                        Image(systemName: selectedAnswer == question.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(selectedAnswer == question.correctAnswer ? PlatzColors.success : PlatzColors.error)
                        Text(selectedAnswer == question.correctAnswer ? "정답!" : "오답")
                            .font(PlatzTypography.bodyBold)
                            .foregroundColor(selectedAnswer == question.correctAnswer ? PlatzColors.success : PlatzColors.error)
                    }
                    Text(question.explanation)
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textSecondary)
                }
                .padding(PlatzSpacing.md)
                .background(PlatzColors.surface)
                .cornerRadius(PlatzRadius.medium)
            }
            
            Spacer()
            
            // Button
            if showFeedback {
                Button("다음") { onNext() }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
            } else {
                Button("확인") { onSubmit() }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
                    .disabled(selectedAnswer == nil)
                    .opacity(selectedAnswer == nil ? 0.5 : 1)
            }
        }
        .padding(PlatzSpacing.md)
    }
}

// MARK: - Option Button
struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if let correct = isCorrect, correct { return PlatzColors.success.opacity(0.2) }
        if isWrong { return PlatzColors.error.opacity(0.2) }
        return isSelected ? PlatzColors.primary.opacity(0.2) : PlatzColors.surface
    }
    
    var borderColor: Color {
        if let correct = isCorrect, correct { return PlatzColors.success }
        if isWrong { return PlatzColors.error }
        return isSelected ? PlatzColors.primary : PlatzColors.border
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(PlatzTypography.body)
                    .foregroundColor(PlatzColors.textPrimary)
                Spacer()
                if let correct = isCorrect, correct {
                    Image(systemName: "checkmark").foregroundColor(PlatzColors.success)
                } else if isWrong {
                    Image(systemName: "xmark").foregroundColor(PlatzColors.error)
                }
            }
            .padding(PlatzSpacing.md)
            .background(backgroundColor)
            .cornerRadius(PlatzRadius.medium)
            .overlay(RoundedRectangle(cornerRadius: PlatzRadius.medium).stroke(borderColor, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quiz Result Content
struct QuizResultContent: View {
    let quiz: Quiz
    let correctCount: Int
    let totalCount: Int
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var score: Int { totalCount > 0 ? Int((Double(correctCount) / Double(totalCount)) * 100) : 0 }
    var isPassed: Bool { score >= quiz.passingScore }
    
    var body: some View {
        VStack(spacing: PlatzSpacing.xl) {
            Spacer()
            
            // Score Circle
            ZStack {
                Circle()
                    .stroke(PlatzColors.border, lineWidth: 12)
                    .frame(width: 150, height: 150)
                Circle()
                    .trim(from: 0, to: Double(score) / 100)
                    .stroke(isPassed ? PlatzColors.success : PlatzColors.warning, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(PlatzColors.textPrimary)
                    Text("점")
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
            }
            
            // Message
            Text(isPassed ? "잘했어요! 🎉" : "다시 도전해보세요! 💪")
                .font(PlatzTypography.title2)
                .foregroundColor(PlatzColors.textPrimary)
            
            Text("\(correctCount)/\(totalCount) 정답")
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
            
            Spacer()
            
            // Buttons
            VStack(spacing: PlatzSpacing.sm) {
                Button("다시 풀기") { onRetry() }
                    .buttonStyle(PlatzSecondaryButtonStyle(isFullWidth: true))
                Button("완료") { onDismiss() }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
            }
        }
        .padding(PlatzSpacing.lg)
    }
}
