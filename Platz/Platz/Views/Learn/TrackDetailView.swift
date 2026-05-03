//
//  TrackDetailView.swift
//  Platz
//
//  트랙 상세 화면 (레슨 목록)
//

import SwiftUI

struct TrackDetailView: View {
    let track: LessonTrack
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager

    var lessons: [Lesson] {
        dataManager.lessons(forTrack: track, level: progressManager.selectedLessonLevel)
    }

    var dialogs: [Dialog] {
        guard track == .conversation else { return [] }
        return dataManager.allDialogs(for: progressManager.selectedLessonLevel)
    }

    var nextLesson: Lesson? {
        lessons.first { !progressManager.isLessonCompleted($0.id) }
    }

    var completedCount: Int {
        (lessons.map(\.id) + dialogs.map(\.id)).filter {
            progressManager.isLessonCompleted($0)
        }.count
    }

    var totalCount: Int {
        lessons.count + dialogs.count
    }

    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: PlatzSpacing.lg) {
                    // Track Header
                    TrackHeaderCard(
                        track: track,
                        completedCount: completedCount,
                        totalCount: totalCount
                    )

                    // Next Lesson (if exists)
                    if let next = nextLesson {
                        NextLessonCard(lesson: next)
                    }

                    // All Lessons
                    if !lessons.isEmpty {
                        LessonsListSection(lessons: lessons)
                    }

                    // Specific logic for Conversation Track: Show Dialogs list
                    if track == .conversation {
                        DialogsListSection(dialogs: dialogs)
                    }

                    // Spacer for tab bar
                    Spacer()
                        .frame(height: 100)
                }
                .padding(PlatzSpacing.md)
            }
        }
        .navigationTitle(track.displayName)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Track Header Card
struct TrackHeaderCard: View {
    let track: LessonTrack
    let completedCount: Int
    let totalCount: Int

    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        HStack(spacing: PlatzSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: track.color).opacity(0.2))
                    .frame(width: 56, height: 56)

                Image(systemName: track.icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: track.color))
            }

            // Info
            VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
                Text(track.description)
                    .font(PlatzTypography.body)
                    .foregroundColor(PlatzColors.textSecondary)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(PlatzColors.border)
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: track.color))
                            .frame(width: geometry.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)

                Text("\(completedCount)/\(totalCount) 완료")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
            }
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

// MARK: - Next Lesson Card
struct NextLessonCard: View {
    let lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(PlatzColors.primary)
                Text("다음 추천 레슨")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.primary)
            }

            NavigationLink {
                LessonDetailView(lesson: lesson)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(lesson.title)
                            .font(PlatzTypography.bodyBold)
                            .foregroundColor(PlatzColors.textPrimary)

                        Text("\(lesson.durationMin)분 · \(lesson.level.displayName)")
                            .font(PlatzTypography.caption)
                            .foregroundColor(PlatzColors.textMuted)
                    }

                    Spacer()

                    Text("시작")
                        .font(PlatzTypography.buttonSmall)
                        .foregroundColor(PlatzColors.onPrimary)
                        .padding(.horizontal, PlatzSpacing.md)
                        .padding(.vertical, PlatzSpacing.xs)
                        .background(PlatzColors.primary)
                        .cornerRadius(PlatzRadius.medium)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surfaceRaised)
        .cornerRadius(PlatzRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.large)
                .stroke(PlatzColors.primary.opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - Lessons List Section
struct LessonsListSection: View {
    let lessons: [Lesson]
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("모든 레슨")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)

            VStack(spacing: PlatzSpacing.xs) {
                ForEach(lessons) { lesson in
                    NavigationLink {
                        LessonDetailView(lesson: lesson)
                    } label: {
                        LessonRow(
                            lesson: lesson,
                            isCompleted: progressManager.isLessonCompleted(lesson.id)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}



// MARK: - Dialogs List Section
struct DialogsListSection: View {
    let dialogs: [Dialog]

    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            Text("회화 목록")
                .font(PlatzTypography.captionBold)
                .foregroundColor(PlatzColors.textMuted)
                .padding(.top, PlatzSpacing.md)

            VStack(spacing: PlatzSpacing.xs) {
                ForEach(dialogs) { dialog in
                    NavigationLink {
                        DialogView(dialog: dialog)
                    } label: {
                        DialogListRow(dialog: dialog)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TrackDetailView(track: .alphabet)
            .environmentObject(DataManager.shared)
            .environmentObject(ProgressManager())
    }
}
