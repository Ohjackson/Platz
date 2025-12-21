//
//  HomeView.swift
//  Platz
//
//  홈 화면
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showSettings = false
    @State private var showQuoteExplanation = false
    @State private var selectedTab = 1 // For navigation to Germany tab
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PlatzSpacing.lg) {
                        // Quote Card
                        if let quote = dataManager.todayQuote {
                            QuoteCard(
                                quote: quote,
                                onExplainTap: {
                                    showQuoteExplanation = true
                                },
                                onShareTap: {
                                    shareQuote(quote)
                                }
                            )
                        }
                        
                        // Continue Learning Section
                        if let lastLessonId = progressManager.lastLessonId,
                           let lesson = dataManager.lesson(byId: lastLessonId) {
                            ContinueLearningCard(lesson: lesson)
                        } else {
                            FirstLearningCard()
                        }
                        
                        // Today's Germany
                        if let article = dataManager.recommendedArticle {
                            TodayGermanyCard(article: article)
                        }
                        
                        // Quick Start
                        QuickStartSection()
                        
                        // Spacer for tab bar
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("Platz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(PlatzColors.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showQuoteExplanation) {
                if let quote = dataManager.todayQuote {
                    QuoteExplanationSheet(quote: quote)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
    
    private func shareQuote(_ quote: Quote) {
        let text = "\"\(quote.de)\"\n\n\(quote.ko)\n\n— platz 앱에서"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Continue Learning Card
struct ContinueLearningCard: View {
    let lesson: Lesson
    
    var body: some View {
        NavigationLink {
            LessonDetailView(lesson: lesson)
        } label: {
            HStack(spacing: PlatzSpacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: lesson.track.color).opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "play.fill")
                        .foregroundColor(Color(hex: lesson.track.color))
                }
                
                // Content
                VStack(alignment: .leading, spacing: PlatzSpacing.xxs) {
                    Text("이어하기")
                        .font(PlatzTypography.captionBold)
                        .foregroundColor(PlatzColors.primary)
                    
                    Text(lesson.title)
                        .font(PlatzTypography.bodyBold)
                        .foregroundColor(PlatzColors.textPrimary)
                    
                    Text(lesson.track.displayName)
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(PlatzColors.textMuted)
            }
            .padding(PlatzSpacing.md)
            .background(PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - First Learning Card
struct FirstLearningCard: View {
    var body: some View {
                NavigationLink {
                    LearnView(navigationId: .constant(UUID()))
                } label: {
            HStack(spacing: PlatzSpacing.md) {
                ZStack {
                    Circle()
                        .fill(PlatzColors.primary.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "sparkles")
                        .foregroundColor(PlatzColors.primary)
                }
                
                VStack(alignment: .leading, spacing: PlatzSpacing.xxs) {
                    Text("첫 학습 시작하기")
                        .font(PlatzTypography.bodyBold)
                        .foregroundColor(PlatzColors.textPrimary)
                    
                    Text("알파벳부터 차근차근 배워보세요")
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(PlatzColors.textMuted)
            }
            .padding(PlatzSpacing.md)
            .background(PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.primary.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Today's Germany Card
struct TodayGermanyCard: View {
    let article: Article
    
    var body: some View {
        NavigationLink {
            ArticleDetailView(article: article)
        } label: {
            VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                HStack {
                    Text("도이칠란트 상식")
                        .font(PlatzTypography.captionBold)
                        .foregroundColor(PlatzColors.primary)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                
                Text(article.title)
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(article.summary)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: PlatzSpacing.xs) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("\(article.readTime)분")
                        .font(PlatzTypography.caption)
                }
                .foregroundColor(PlatzColors.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(PlatzSpacing.md)
            .background(PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Start Section
struct QuickStartSection: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("저장된 아티클")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            NavigationLink {
                BookmarkedArticlesView()
            } label: {
                HStack(spacing: PlatzSpacing.sm) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(PlatzColors.primary)
                    
                    Text("북마크 보기")
                        .font(PlatzTypography.bodyBold)
                        .foregroundColor(PlatzColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(progressManager.bookmarkedArticleIds.count)")
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                .padding(PlatzSpacing.md)
                .background(PlatzColors.surface)
                .cornerRadius(PlatzRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: PlatzRadius.large)
                        .stroke(PlatzColors.border, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Quote Explanation Sheet
struct QuoteExplanationSheet: View {
    let quote: Quote
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: PlatzSpacing.lg) {
                        // Quote
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            Text(quote.de)
                                .font(PlatzTypography.title2)
                                .foregroundColor(PlatzColors.textPrimary)
                            
                            Text(quote.ko)
                                .font(PlatzTypography.body)
                                .foregroundColor(PlatzColors.textSecondary)
                            
                            if let author = quote.author {
                                Text("— \(author)")
                                    .font(PlatzTypography.caption)
                                    .foregroundColor(PlatzColors.textMuted)
                            }
                        }
                        .padding(PlatzSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(PlatzColors.surfaceRaised)
                        .cornerRadius(PlatzRadius.medium)
                        
                        // Explanation
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(PlatzColors.primary)
                                Text("해설")
                                    .font(PlatzTypography.bodyBold)
                                    .foregroundColor(PlatzColors.textPrimary)
                            }
                            
                            Text(quote.explain)
                                .font(PlatzTypography.body)
                                .foregroundColor(PlatzColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(PlatzSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.medium)
                        
                        // Tags
                        if !quote.tags.isEmpty {
                            HStack(spacing: PlatzSpacing.xs) {
                                ForEach(quote.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(PlatzTypography.caption)
                                        .foregroundColor(PlatzColors.tagText)
                                        .padding(.horizontal, PlatzSpacing.xs)
                                        .padding(.vertical, 4)
                                        .background(PlatzColors.tag)
                                        .cornerRadius(PlatzRadius.small)
                                }
                            }
                        }
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("오늘의 한마디")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                    .foregroundColor(PlatzColors.primary)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
}
