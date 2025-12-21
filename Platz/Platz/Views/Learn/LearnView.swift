//
//  LearnView.swift
//  Platz
//
//  학습 탭 메인 화면
//

import SwiftUI

struct LearnView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    @Binding var navigationId: UUID
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PlatzSpacing.lg) {
                        // Progress Summary
                        ProgressSummaryCard()
                        
                        // Tracks
                        TracksSection()
                        
                        // Conversations Section
                        ConversationsSection()
                        
                        // Spacer for tab bar
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("학습")
            .navigationBarTitleDisplayMode(.large)
        }
        .id(navigationId)
    }
}

// MARK: - Progress Summary Card
struct ProgressSummaryCard: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var dataManager: DataManager
    
    var totalLessons: Int {
        dataManager.lessons.count + dataManager.allDialogs.count
    }
    
    var completedLessons: Int {
        progressManager.completedLessonsCount
    }
    
    var progress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons) / Double(totalLessons)
    }
    
    var body: some View {
        HStack(spacing: PlatzSpacing.lg) {
            // Progress Ring
            ProgressRing(progress: progress, size: 70, lineWidth: 6)
            
            // Stats
            VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
                Text("학습 현황")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.textMuted)
                
                HStack(spacing: PlatzSpacing.lg) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(completedLessons)")
                            .font(PlatzTypography.title2)
                            .foregroundColor(PlatzColors.primary)
                        Text("완료한 레슨")
                            .font(PlatzTypography.caption)
                            .foregroundColor(PlatzColors.textMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(progressManager.streak)")
                            .font(PlatzTypography.title2)
                            .foregroundColor(PlatzColors.warning)
                        Text("연속 학습일")
                            .font(PlatzTypography.caption)
                            .foregroundColor(PlatzColors.textMuted)
                    }
                }
            }
            
            Spacer()
        }
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.large)
                .stroke(PlatzColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Tracks Section
struct TracksSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    
    // Only show learning tracks (not quiz)
    var learningTracks: [LessonTrack] {
        [.alphabet, .numbers, .grammar, .conversation]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("학습 트랙")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
            
            VStack(spacing: PlatzSpacing.xs) {
                ForEach(learningTracks, id: \.self) { track in
                    let lessons = dataManager.lessons(forTrack: track)
                    let completedCount = lessons.filter { progressManager.isLessonCompleted($0.id) }.count
                    
                    NavigationLink {
                        TrackDetailView(track: track)
                    } label: {
                        TrackCard(
                            track: track,
                            completedCount: completedCount,
                            totalCount: lessons.count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Conversations Section
struct ConversationsSection: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            HStack {
                Text("회화 연습")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.textMuted)
                
                Spacer()
                
                NavigationLink {
                    AllDialogsView()
                } label: {
                    Text("전체 보기")
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.link)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: PlatzSpacing.sm) {
                    ForEach(dataManager.allDialogs.prefix(10)) { dialog in
                        NavigationLink {
                            DialogView(dialog: dialog)
                        } label: {
                            DialogPreviewCard(dialog: dialog)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Dialog Preview Card
struct DialogPreviewCard: View {
    let dialog: Dialog
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
            // Topic icon
            Image(systemName: DialogTopic(rawValue: dialog.topic)?.icon ?? "bubble.left.fill")
                .font(.title2)
                .foregroundColor(PlatzColors.primary)
                .padding(.bottom, 4)
            
            Text(dialog.title)
                .font(PlatzTypography.bodyBold)
                .foregroundColor(PlatzColors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Text("\(dialog.lines.count)문장")
                .font(PlatzTypography.caption)
                .foregroundColor(PlatzColors.textMuted)
        }
        .frame(width: 140, height: 110, alignment: .leading)
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.large)
                .stroke(PlatzColors.border, lineWidth: 1)
        )
    }
}

// MARK: - All Dialogs View
struct AllDialogsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: PlatzSpacing.sm) {
                    ForEach(dataManager.allDialogs) { dialog in
                        NavigationLink {
                            DialogView(dialog: dialog)
                        } label: {
                            DialogListRow(dialog: dialog)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(PlatzSpacing.md)
                
                Spacer()
                    .frame(height: 100)
            }
        }
        .navigationTitle("회화 연습")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DialogListRow: View {
    let dialog: Dialog
    
    var body: some View {
        HStack(spacing: PlatzSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(PlatzColors.primary.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: DialogTopic(rawValue: dialog.topic)?.icon ?? "bubble.left.fill")
                    .foregroundColor(PlatzColors.primary)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(dialog.title)
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
                
                Text("\(dialog.lines.count)문장 · \(dialog.keywords.count)개 키워드")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
            }
            
            Spacer()
            
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
}

// MARK: - Preview
#Preview {
    LearnView(navigationId: .constant(UUID()))
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
}
