//
//  LessonDetailView.swift
//  Platz
//
//  레슨 상세 화면
//

import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showQuiz = false
    
    var quiz: Quiz? {
        if let quizId = lesson.miniQuizId {
            return dataManager.quiz(byId: quizId)
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: PlatzSpacing.lg) {
                    // Header
                    LessonHeader(lesson: lesson)
                    
                    // Content
                    if !lesson.contentMarkdown.isEmpty {
                        ContentSection(content: lesson.contentMarkdown)
                    }
                    
                    // Examples
                    if !lesson.examples.isEmpty {
                        ExamplesSection(examples: lesson.examples)
                    }
                    
                    // Tips
                    if let tips = lesson.tips, !tips.isEmpty {
                        TipBox(tips: tips)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
                .padding(PlatzSpacing.md)
            }
            
            // Bottom Buttons
            VStack {
                Spacer()
                
                BottomButtonsBar(
                    hasQuiz: quiz != nil,
                    isCompleted: progressManager.isLessonCompleted(lesson.id),
                    onQuizTap: { showQuiz = true },
                    onCompleteTap: completeLesson
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuiz) {
            if let quiz = quiz {
                QuizView(quiz: quiz)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                progressManager.lastLessonId = lesson.id
            }
        }
    }
    
    private func completeLesson() {
        progressManager.completeLesson(lesson.id, duration: lesson.durationMin)
    }
}

// MARK: - Lesson Header
struct LessonHeader: View {
    let lesson: Lesson
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            // Track badge
            HStack(spacing: PlatzSpacing.xs) {
                Image(systemName: lesson.track.icon)
                Text(lesson.track.displayName)
            }
            .font(PlatzTypography.captionBold)
            .foregroundColor(Color(hex: lesson.track.color))
            
            // Title
            Text(lesson.title)
                .font(PlatzTypography.title1)
                .foregroundColor(PlatzColors.textPrimary)
            
            // Meta
            HStack(spacing: PlatzSpacing.md) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\(lesson.durationMin)분")
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "chart.bar")
                    Text(lesson.level.displayName)
                }
            }
            .font(PlatzTypography.caption)
            .foregroundColor(PlatzColors.textMuted)
        }
    }
}

// MARK: - Content Section
struct ContentSection: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("설명")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            MarkdownContent(text: content)
                .padding(PlatzSpacing.md)
                .background(PlatzColors.surface)
                .cornerRadius(PlatzRadius.medium)
        }
    }
}

// MARK: - Examples Section
struct ExamplesSection: View {
    let examples: [LessonExample]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("예시")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: PlatzSpacing.sm) {
                    ForEach(examples) { example in
                        ExampleCard(example: example)
                            .frame(width: 300, height: 200)
                    }
                }
            }
        }
    }
}

// MARK: - Bottom Buttons Bar
struct BottomButtonsBar: View {
    let hasQuiz: Bool
    let isCompleted: Bool
    let onQuizTap: () -> Void
    let onCompleteTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(PlatzColors.border)
            
            HStack(spacing: PlatzSpacing.sm) {
                if hasQuiz {
                    Button(action: onQuizTap) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("미니퀴즈")
                        }
                    }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
                }
                
                if isCompleted {
                    Button(action: onCompleteTap) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("완료됨")
                        }
                    }
                    .buttonStyle(PlatzSecondaryButtonStyle(isFullWidth: true))
                    .disabled(true)
                    .opacity(0.6)
                } else {
                    Button(action: onCompleteTap) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("완료하기")
                        }
                    }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
                }
            }
            .padding(.horizontal, PlatzSpacing.md)
            .padding(.top, PlatzSpacing.md)
            .padding(.bottom, PlatzSpacing.lg + 80) // Extra padding for tab bar
        }
        .background(PlatzColors.surface)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LessonDetailView(lesson: Lesson(
            id: "test",
            track: .alphabet,
            title: "독일어 알파벳 소개",
            level: .a1,
            durationMin: 5,
            contentMarkdown: "독일어 알파벳은 영어와 비슷하지만 **4개의 특수문자**가 있습니다.",
            examples: [
                LessonExample(de: "Ä", ko: "에", note: "입을 에 모양으로", pronunciation: "에")
            ],
            tips: ["움라우트는 모음 위의 두 점입니다"],
            miniQuizId: nil,
            order: 1
        ))
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
    }
}
