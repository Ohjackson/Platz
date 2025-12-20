//
//  PlatzCard.swift
//  Platz
//
//  재사용 가능한 카드 컴포넌트
//

import SwiftUI

struct PlatzCard<Content: View>: View {
    let isRaised: Bool
    let content: Content
    
    init(raised: Bool = false, @ViewBuilder content: () -> Content) {
        self.isRaised = raised
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(PlatzSpacing.md)
            .background(isRaised ? PlatzColors.surfaceRaised : PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
    }
}

// MARK: - Quote Card
struct QuoteCard: View {
    let quote: Quote
    let onExplainTap: () -> Void
    let onShareTap: () -> Void
    @ObservedObject var speechManager = SpeechManager.shared
    
    var isCurrentlySpeaking: Bool {
        speechManager.currentlySpeakingText == quote.de && speechManager.isSpeaking
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.md) {
            // Header
            HStack {
                Text("오늘의 한마디")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.primary)
                
                Spacer()
                
                Button {
                    speechManager.speak(quote.de)
                } label: {
                    Image(systemName: isCurrentlySpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.primary.opacity(0.5))
                }
            }
            
            // German Quote
            Text(quote.de)
                .font(PlatzTypography.quote)
                .foregroundColor(PlatzColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Korean Translation
            Text(quote.ko)
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
            
            // Author (if exists)
            if let author = quote.author {
                Text("— \(author)")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
            }
            
            // Buttons
            HStack(spacing: PlatzSpacing.sm) {
                Button(action: onExplainTap) {
                    HStack(spacing: PlatzSpacing.xxs) {
                        Image(systemName: "lightbulb.fill")
                        Text("해설 보기")
                    }
                }
                .buttonStyle(PlatzSecondaryButtonStyle())
                
                Button(action: onShareTap) {
                    HStack(spacing: PlatzSpacing.xxs) {
                        Image(systemName: "square.and.arrow.up")
                        Text("공유")
                    }
                }
                .buttonStyle(PlatzSecondaryButtonStyle())
                
                Spacer()
            }
        }
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surfaceRaised)
        .cornerRadius(PlatzRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.large)
                .stroke(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: ArticleCategory
    let articleCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            // Icon
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(PlatzColors.primary)
            
            Spacer()
            
            // Title
            Text(category.displayName)
                .font(PlatzTypography.bodyBold)
                .foregroundColor(PlatzColors.textPrimary)
            
            // Count
            Text("\(articleCount)개의 글")
                .font(PlatzTypography.caption)
                .foregroundColor(PlatzColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.large)
                .stroke(PlatzColors.border, lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Track Card
struct TrackCard: View {
    let track: LessonTrack
    let completedCount: Int
    let totalCount: Int
    
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: PlatzSpacing.md) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(Color(hex: track.color).opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: track.icon)
                    .font(.title3)
                    .foregroundColor(Color(hex: track.color))
            }
            
            // Content
            VStack(alignment: .leading, spacing: PlatzSpacing.xxs) {
                Text(track.displayName)
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
                
                Text(track.description)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
                    .lineLimit(1)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(PlatzColors.border)
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(hex: track.color))
                            .frame(width: geometry.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            // Progress text
            Text("\(completedCount)/\(totalCount)")
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
        .contentShape(Rectangle())
    }
}

// MARK: - Article Row
struct ArticleRow: View {
    let article: Article
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: PlatzSpacing.sm) {
            VStack(alignment: .leading, spacing: PlatzSpacing.xxs) {
                // Title
                Text(article.title)
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
                    .lineLimit(2)
                
                // Summary
                Text(article.summary)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textSecondary)
                    .lineLimit(2)
                
                // Meta
                HStack(spacing: PlatzSpacing.xs) {
                    // Read time
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                        Text("\(article.readTime)분")
                    }
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
                    
                    // Tags
                    ForEach(article.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 11))
                            .foregroundColor(PlatzColors.tagText)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(PlatzColors.tag)
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            // Bookmark button
            Button(action: onBookmarkTap) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(isBookmarked ? PlatzColors.primary : PlatzColors.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(PlatzSpacing.sm)
        .contentShape(Rectangle()) // Make the entire row tappable for NavigationLink
    }
}

// MARK: - Lesson Row
struct LessonRow: View {
    let lesson: Lesson
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: PlatzSpacing.sm) {
            // Completion indicator
            ZStack {
                Circle()
                    .stroke(isCompleted ? PlatzColors.success : PlatzColors.border, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(PlatzColors.success)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.title)
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
                
                HStack(spacing: PlatzSpacing.xs) {
                    Text(lesson.level.displayName)
                        .font(.system(size: 11))
                        .foregroundColor(PlatzColors.tagText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(PlatzColors.tag)
                        .cornerRadius(4)
                    
                    Text("\(lesson.durationMin)분")
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(PlatzColors.textMuted)
        }
        .padding(PlatzSpacing.sm)
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.medium)
        .contentShape(Rectangle())
    }
}

// MARK: - Quick Start Card
struct QuickStartCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: PlatzSpacing.sm) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(PlatzColors.primary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(PlatzTypography.bodyBold)
                        .foregroundColor(PlatzColors.textPrimary)
                    
                    Text(subtitle)
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(PlatzColors.primary)
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

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            CategoryCard(
                category: .general,
                articleCount: 5
            )
            
            TrackCard(
                track: .alphabet,
                completedCount: 2,
                totalCount: 5
            )
            
            QuickStartCard(
                title: "독일 읽기",
                subtitle: "문화, 정치, 행정 알아보기",
                icon: "book.fill"
            ) {}
        }
        .padding()
    }
    .background(PlatzColors.background)
}
