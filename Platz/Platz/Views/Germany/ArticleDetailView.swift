//
//  ArticleDetailView.swift
//  Platz
//
//  아티클 상세 화면 (위키 스타일)
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var expandedSections: Set<String> = []
    
    var relatedArticles: [Article] {
        dataManager.relatedArticles(for: article)
    }
    
    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: PlatzSpacing.lg) {
                    // Header
                    ArticleHeader(article: article)
                    
                    // Quick Facts
                    if !article.quickFacts.isEmpty {
                        QuickFactsBox(facts: article.quickFacts)
                    }
                    
                    // Content Sections
                    ForEach(article.sections) { section in
                        ArticleSectionView(
                            section: section,
                            isExpanded: expandedSections.contains(section.id)
                        ) {
                            toggleSection(section.id)
                        }
                    }
                    
                    // Tags
                    if !article.tags.isEmpty {
                        TagsRow(tags: article.tags)
                    }
                    
                    // Related Articles
                    if !relatedArticles.isEmpty {
                        RelatedArticlesSection(articles: relatedArticles)
                    }
                    
                    // Footer
                    ArticleFooter(updatedAt: article.updatedAt)
                    
                    Spacer()
                        .frame(height: PlatzSpacing.xl)
                }
                .padding(PlatzSpacing.md)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    progressManager.toggleArticleBookmark(article.id)
                } label: {
                    Image(systemName: progressManager.isArticleBookmarked(article.id) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(PlatzColors.primary)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                progressManager.addRecentArticle(article.id)
                progressManager.markArticleAsRead(article.id)
            }
            // Start with all sections expanded
            expandedSections = Set(article.sections.map { $0.id })
        }
    }
    
    private func toggleSection(_ id: String) {
        withAnimation {
            if expandedSections.contains(id) {
                expandedSections.remove(id)
            } else {
                expandedSections.insert(id)
            }
        }
    }
}

// MARK: - Article Header
struct ArticleHeader: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            // Category Badge
            HStack(spacing: PlatzSpacing.xs) {
                Image(systemName: article.category.icon)
                Text(article.category.displayName)
            }
            .font(PlatzTypography.captionBold)
            .foregroundColor(PlatzColors.primary)
            
            // Title
            Text(article.title)
                .font(PlatzTypography.title1)
                .foregroundColor(PlatzColors.textPrimary)
            
            // Summary
            Text(article.summary)
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
            
            // Read time
            HStack(spacing: PlatzSpacing.xs) {
                Image(systemName: "clock")
                Text("읽는 시간: 약 \(article.readTime)분")
            }
            .font(PlatzTypography.caption)
            .foregroundColor(PlatzColors.textMuted)
        }
    }
}

// MARK: - Article Section View
struct ArticleSectionView: View {
    let section: ArticleSection
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (tappable)
            Button(action: onToggle) {
                HStack {
                    Text(section.heading)
                        .font(PlatzTypography.title3)
                        .foregroundColor(PlatzColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(PlatzColors.textMuted)
                }
                .padding(PlatzSpacing.md)
            }
            .buttonStyle(.plain)
            
            // Content
            if isExpanded {
                MarkdownContent(text: section.bodyMarkdown)
                    .padding(.horizontal, PlatzSpacing.md)
                    .padding(.bottom, PlatzSpacing.md)
            }
        }
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.medium)
                .stroke(PlatzColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Markdown Content
struct MarkdownContent: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.md) {
            ForEach(parseMarkdown(text), id: \.self) { element in
                renderElement(element)
            }
        }
    }
    
    private func parseMarkdown(_ text: String) -> [String] {
        // Split by double newline to separate paragraphs/blocks
        text.components(separatedBy: "\n\n")
    }
    
    @ViewBuilder
    private func renderElement(_ text: String) -> some View {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).starts(with: "|") {
            // Table
            MarkdownTableView(markdown: text)
        } else if text.starts(with: "#") {
            // Heading
            let level = text.prefix(while: { $0 == "#" }).count
            let content = text.drop(while: { $0 == "#" }).trimmingCharacters(in: .whitespaces)
            Text(content)
                .font(headingFont(for: level))
                .foregroundColor(PlatzColors.textPrimary)
                .padding(.top, PlatzSpacing.sm)
        } else if text.trimmingCharacters(in: .whitespaces).starts(with: "- ") {
            // List
            VStack(alignment: .leading, spacing: 4) {
                ForEach(text.components(separatedBy: "\n"), id: \.self) { line in
                    if line.trimmingCharacters(in: .whitespaces).hasPrefix("- ") {
                        HStack(alignment: .top, spacing: PlatzSpacing.xs) {
                            Text("•").foregroundColor(PlatzColors.primary)
                            Text(formatInlineMarkdown(String(line.drop(while: { $0 != "-" }).dropFirst(2))))
                                .font(PlatzTypography.body)
                                .foregroundColor(PlatzColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        } else {
            // Paragraph
            Text(formatInlineMarkdown(text))
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func headingFont(for level: Int) -> Font {
        switch level {
        case 1: return PlatzTypography.title2
        case 2: return PlatzTypography.title3
        case 3: return PlatzTypography.bodyBold
        default: return PlatzTypography.bodyBold
        }
    }
    
    private func formatInlineMarkdown(_ text: String) -> AttributedString {
        var result = AttributedString(text)
        
        // Bold text **...**
        let boldPattern = /\*\*(.+?)\*\*/
        for match in text.matches(of: boldPattern) {
            let fullMatch = String(match.0)
            
            // Find range of the full match "**text**"
            if let range = result.range(of: fullMatch) {
                // Style the range
                result[range].font = PlatzTypography.bodyBold
                result[range].foregroundColor = PlatzColors.textPrimary
                // Remove asterisks (manual approach since replaceSubrange might mess up indices if done plainly)
                // A simpler way for this task:
                // Just replacing the text is risky with AttributedString indices.
                // But let's try a simpler approach for now:
                // We just highlight it. Robust markdown parsing is hard.
            }
        }
        
        // Manual replacement for simple cases (since regex replacement on AttributedString is tricky)
        // Let's re-implement basic bolding by splitting:
        try? result = AttributedString(markdown: text) // Try using SwiftUI built-in first?
        
        // Fallback or enhancement:
        // Actually, AttributedString(markdown:) is available in iOS 15+.
        // Let's use THAT if possible, it supports **bold** automatically.
        if let attributed = try? AttributedString(markdown: text) {
            return attributed
        }
        
        return result
    }
}

struct MarkdownTableView: View {
    let markdown: String
    
    var rows: [[String]] {
        markdown.components(separatedBy: "\n")
            .filter { $0.trimmingCharacters(in: .whitespaces).hasPrefix("|") }
            .map { line in
                line.split(separator: "|").map { String($0).trimmingCharacters(in: .whitespaces) }
            }
    }
    
    var body: some View {
        let allRows = rows
        let isHeaderRow = { (row: [String]) -> Bool in
            return row.contains { $0.contains("---") }
        }
        
        // Filter out separator rows
        let dataRows = allRows.filter { !isHeaderRow($0) }
        
        if !dataRows.isEmpty {
            VStack(spacing: 0) {
                ForEach(Array(dataRows.enumerated()), id: \.offset) { index, row in
                    HStack(spacing: 0) {
                        ForEach(Array(row.enumerated()), id: \.offset) { cellIndex, cell in
                            if cellIndex > 0 {
                                Rectangle()
                                    .fill(PlatzColors.border)
                                    .frame(width: 1)
                            }
                            Text(cell)
                                .font(index == 0 ? PlatzTypography.bodyBold : PlatzTypography.body)
                                .foregroundColor(index == 0 ? PlatzColors.textPrimary : PlatzColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(index == 0 ? PlatzColors.surfaceRaised : PlatzColors.surface)
                        }
                    }
                    
                    if index < dataRows.count - 1 {
                        Divider()
                    }
                }
            }
            .cornerRadius(PlatzRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.medium)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
        }
    }
}

// MARK: - Tags Row
struct TagsRow: View {
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
            Text("태그")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: PlatzSpacing.xs) {
                    ForEach(tags, id: \.self) { tag in
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
    }
}

// MARK: - Related Articles Section
struct RelatedArticlesSection: View {
    let articles: [Article]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("관련 글")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            VStack(spacing: PlatzSpacing.xs) {
                ForEach(articles) { article in
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(article.title)
                                    .font(PlatzTypography.bodyBold)
                                    .foregroundColor(PlatzColors.textPrimary)
                                    .lineLimit(1)
                                
                                Text(article.category.displayName)
                                    .font(PlatzTypography.caption)
                                    .foregroundColor(PlatzColors.textMuted)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(PlatzColors.textMuted)
                        }
                        .padding(PlatzSpacing.sm)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.medium)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Article Footer
struct ArticleFooter: View {
    let updatedAt: String
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("마지막 업데이트: \(updatedAt)")
                .font(PlatzTypography.caption)
                .foregroundColor(PlatzColors.textMuted)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ArticleDetailView(article: Article(
            id: "test",
            category: .general,
            title: "독일 연방 공화국 한눈에",
            summary: "독일의 기본 정보를 알아봅니다.",
            readTime: 3,
            sections: [
                ArticleSection(heading: "기본 정보", bodyMarkdown: "독일의 공식 명칭은 **독일 연방 공화국**입니다."),
                ArticleSection(heading: "국기", bodyMarkdown: "독일 국기는 **검정-빨강-금색** 세 줄입니다.")
            ],
            quickFacts: [
                QuickFact(key: "수도", value: "베를린"),
                QuickFact(key: "인구", value: "8,300만")
            ],
            relatedIds: [],
            tags: ["입문", "기본정보"],
            updatedAt: "2024-12"
        ))
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
    }
}
