//
//  DialogView.swift
//  Platz
//
//  회화 상세 화면
//

import SwiftUI

struct DialogView: View {
    let dialog: Dialog
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showTranslation = true
    @State private var showQuiz = false

    var quiz: Quiz? {
        if let quizId = dialog.quizId {
            return dataManager.quiz(byId: quizId)
        }
        return nil
    }

    var body: some View {
        ZStack {
            PlatzColors.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: PlatzSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                        HStack(spacing: PlatzSpacing.md) {
                            HStack(spacing: PlatzSpacing.xs) {
                                Image(systemName: DialogTopic(rawValue: dialog.topic)?.icon ?? "bubble.left.fill")
                                Text(DialogTopic(rawValue: dialog.topic)?.displayName ?? dialog.topic)
                            }

                            HStack(spacing: PlatzSpacing.xs) {
                                Image(systemName: "chart.bar")
                                Text(dialog.level.displayName)
                            }
                        }
                        .font(PlatzTypography.captionBold)
                        .foregroundColor(PlatzColors.primary)

                        Text(dialog.title)
                            .font(PlatzTypography.title1)
                            .foregroundColor(PlatzColors.textPrimary)
                    }

                    // Toggle
                    HStack {
                        Text("해석 보기")
                            .font(PlatzTypography.body)
                            .foregroundColor(PlatzColors.textPrimary)
                        Spacer()
                        Toggle("", isOn: $showTranslation)
                            .toggleStyle(SwitchToggleStyle(tint: PlatzColors.primary))
                            .labelsHidden()
                    }
                    .padding(PlatzSpacing.sm)
                    .background(PlatzColors.surface)
                    .cornerRadius(PlatzRadius.medium)

                    // Lines
                    VStack(spacing: PlatzSpacing.md) {
                        ForEach(Array(dialog.lines.enumerated()), id: \.offset) { index, line in
                            DialogBubble(line: line, showTranslation: showTranslation, isLeft: line.speaker == "A")
                        }
                    }

                    // Keywords
                    if !dialog.keywords.isEmpty {
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            HStack {
                                Image(systemName: "key.fill").foregroundColor(PlatzColors.primary)
                                Text("핵심 표현").font(PlatzTypography.bodyBold).foregroundColor(PlatzColors.textPrimary)
                            }

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: PlatzSpacing.xs) {
                                ForEach(dialog.keywords) { kw in
                                    KeywordChip(keyword: kw)
                                }
                            }
                        }
                        .padding(PlatzSpacing.md)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.large)
                    }

                    // Complete Button
                    Button {
                        progressManager.completeLesson(dialog.id, duration: 5)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("완료하기")
                            .font(PlatzTypography.button)
                            .foregroundColor(PlatzColors.onPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, PlatzSpacing.md)
                            .background(PlatzColors.primary)
                            .cornerRadius(PlatzRadius.large)
                    }
                    .padding(.top, PlatzSpacing.md)

                    Spacer().frame(height: 100)
                }
                .padding(PlatzSpacing.md)
            }

            // Removed existing bottom footer code since we moved the button inside content
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuiz) { if let q = quiz { QuizView(quiz: q) } }
    }
}
