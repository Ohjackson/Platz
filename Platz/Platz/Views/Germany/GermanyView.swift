//
//  GermanyView.swift
//  Platz
//
//  독일 탭 메인 화면
//

import SwiftUI

struct GermanyView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showBookmarks = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PlatzSpacing.lg) {
                        // Categories Grid
                        CategoriesGrid()
                        
                        // Popular Articles
                        PopularArticlesSection()
                        
                        // Spacer for tab bar
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("독일")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBookmarks = true
                    } label: {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(PlatzColors.primary)
                    }
                }
            }
            .sheet(isPresented: $showBookmarks) {
                BookmarksView()
            }
        }
    }
}



// MARK: - Categories Grid
struct CategoriesGrid: View {
    @EnvironmentObject var dataManager: DataManager
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("카테고리")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            LazyVGrid(columns: columns, spacing: PlatzSpacing.sm) {
                ForEach(ArticleCategory.allCases, id: \.self) { category in
                    NavigationLink {
                        CategoryListView(category: category)
                    } label: {
                        CategoryCard(
                            category: category,
                            articleCount: dataManager.articles(forCategory: category).count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Popular Articles Section
struct PopularArticlesSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("인기 글")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            VStack(spacing: 0) {
                ForEach(dataManager.articles.prefix(5)) { article in
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        ArticleRow(
                            article: article,
                            isBookmarked: progressManager.isArticleBookmarked(article.id),
                            onBookmarkTap: {
                                progressManager.toggleArticleBookmark(article.id)
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    
                    if article.id != dataManager.articles.prefix(5).last?.id {
                        Divider()
                            .background(PlatzColors.border)
                    }
                }
            }
            .background(PlatzColors.surface)
            .cornerRadius(PlatzRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.large)
                    .stroke(PlatzColors.border, lineWidth: 1)
            )
        }
    }
}



// MARK: - Category List View
struct CategoryListView: View {
    let category: ArticleCategory
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    
    var articles: [Article] {
        dataManager.articles(forCategory: category)
    }
    
    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: PlatzSpacing.sm) {
                    // Category Description
                    HStack(spacing: PlatzSpacing.sm) {
                        Image(systemName: category.icon)
                            .font(.title2)
                            .foregroundColor(PlatzColors.primary)
                        
                        Text(category.description)
                            .font(PlatzTypography.body)
                            .foregroundColor(PlatzColors.textSecondary)
                        
                        Spacer()
                    }
                    .padding(PlatzSpacing.md)
                    .background(PlatzColors.surface)
                    .cornerRadius(PlatzRadius.medium)
                    
                    // Articles List
                    VStack(spacing: 0) {
                        ForEach(articles) { article in
                            NavigationLink {
                                ArticleDetailView(article: article)
                            } label: {
                                ArticleRow(
                                    article: article,
                                    isBookmarked: progressManager.isArticleBookmarked(article.id),
                                    onBookmarkTap: {
                                        progressManager.toggleArticleBookmark(article.id)
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                            
                            if article.id != articles.last?.id {
                                Divider()
                                    .background(PlatzColors.border)
                            }
                        }
                    }
                    .background(PlatzColors.surface)
                    .cornerRadius(PlatzRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: PlatzRadius.large)
                            .stroke(PlatzColors.border, lineWidth: 1)
                    )
                }
                .padding(PlatzSpacing.md)
            }
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Bookmarks View
struct BookmarksView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.dismiss) var dismiss
    
    var bookmarkedArticles: [Article] {
        progressManager.bookmarkedArticleIds.compactMap { id in
            dataManager.article(byId: id)
        }
    }
    
    var recentArticles: [Article] {
        progressManager.recentArticleIds.compactMap { id in
            dataManager.article(byId: id)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PlatzSpacing.lg) {
                        // Bookmarked
                        if !bookmarkedArticles.isEmpty {
                            VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                                Text("북마크")
                                    .font(PlatzTypography.captionBold)
                                    .foregroundColor(PlatzColors.textMuted)
                                
                                VStack(spacing: 0) {
                                    ForEach(bookmarkedArticles) { article in
                                        NavigationLink {
                                            ArticleDetailView(article: article)
                                        } label: {
                                            ArticleRow(
                                                article: article,
                                                isBookmarked: true,
                                                onBookmarkTap: {
                                                    progressManager.toggleArticleBookmark(article.id)
                                                }
                                            )
                                        }
                                        .buttonStyle(.plain)
                                        
                                        if article.id != bookmarkedArticles.last?.id {
                                            Divider()
                                                .background(PlatzColors.border)
                                        }
                                    }
                                }
                                .background(PlatzColors.surface)
                                .cornerRadius(PlatzRadius.large)
                            }
                        }
                        
                        // Recent
                        if !recentArticles.isEmpty {
                            VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                                Text("최근 본 글")
                                    .font(PlatzTypography.captionBold)
                                    .foregroundColor(PlatzColors.textMuted)
                                
                                VStack(spacing: 0) {
                                    ForEach(recentArticles) { article in
                                        NavigationLink {
                                            ArticleDetailView(article: article)
                                        } label: {
                                            ArticleRow(
                                                article: article,
                                                isBookmarked: progressManager.isArticleBookmarked(article.id),
                                                onBookmarkTap: {
                                                    progressManager.toggleArticleBookmark(article.id)
                                                }
                                            )
                                        }
                                        .buttonStyle(.plain)
                                        
                                        if article.id != recentArticles.last?.id {
                                            Divider()
                                                .background(PlatzColors.border)
                                        }
                                    }
                                }
                                .background(PlatzColors.surface)
                                .cornerRadius(PlatzRadius.large)
                            }
                        }
                        
                        if bookmarkedArticles.isEmpty && recentArticles.isEmpty {
                            VStack(spacing: PlatzSpacing.md) {
                                Image(systemName: "bookmark")
                                    .font(.largeTitle)
                                    .foregroundColor(PlatzColors.textMuted)
                                
                                Text("아직 저장한 글이 없어요")
                                    .font(PlatzTypography.body)
                                    .foregroundColor(PlatzColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(PlatzSpacing.xxl)
                        }
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("저장한 글")
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
    }
}

// MARK: - Preview
#Preview {
    GermanyView()
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
}
