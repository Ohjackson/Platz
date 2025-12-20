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
                        HStack(spacing: PlatzSpacing.xs) {
                            Image(systemName: DialogTopic(rawValue: dialog.topic)?.icon ?? "bubble.left.fill")
                            Text(DialogTopic(rawValue: dialog.topic)?.displayName ?? dialog.topic)
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
                    
                    Spacer().frame(height: 100)
                }
                .padding(PlatzSpacing.md)
            }
            
            if quiz != nil {
                VStack {
                    Spacer()
                    Button { showQuiz = true } label: {
                        HStack { Image(systemName: "questionmark.circle.fill"); Text("이 대화로 퀴즈") }
                    }
                    .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
                    .padding(PlatzSpacing.md)
                    .background(PlatzColors.background.shadow(color: .black.opacity(0.2), radius: 10, y: -5))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuiz) { if let q = quiz { QuizView(quiz: q) } }
    }
}
