//
//  SettingsView.swift
//  Platz
//
//  설정 화면
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showResetAlert = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background.ignoresSafeArea()
                
                List {
                    // Progress Section
                    Section {
                        HStack {
                            Label("완료한 레슨", systemImage: "checkmark.circle.fill")
                            Spacer()
                            Text("\(progressManager.completedLessonsCount)")
                                .foregroundColor(PlatzColors.textMuted)
                        }
                        
                        HStack {
                            Label("연속 학습일", systemImage: "flame.fill")
                            Spacer()
                            Text("\(progressManager.streak)")
                                .foregroundColor(PlatzColors.textMuted)
                        }
                        
                        HStack {
                            Label("저장한 글", systemImage: "bookmark.fill")
                            Spacer()
                            Text("\(progressManager.bookmarkedArticleIds.count)")
                                .foregroundColor(PlatzColors.textMuted)
                        }
                    } header: {
                        Text("학습 현황")
                    }
                    .listRowBackground(PlatzColors.surface)
                    
                    // Data Section
                    Section {
                        Button(role: .destructive) {
                            showResetAlert = true
                        } label: {
                            Label("진행도 초기화", systemImage: "arrow.counterclockwise")
                        }
                    } header: {
                        Text("데이터")
                    } footer: {
                        Text("진행도를 초기화하면 완료한 레슨, 퀴즈 기록이 삭제됩니다. 북마크는 유지됩니다.")
                    }
                    .listRowBackground(PlatzColors.surface)
                    
                    // Info Section
                    Section {
                        Button {
                            showAbout = true
                        } label: {
                            HStack {
                                Label("제작자 소개", systemImage: "info.circle.fill")
                                    .foregroundColor(PlatzColors.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(PlatzColors.textMuted)
                            }
                        }
                        
                        HStack {
                            Label("버전", systemImage: "number")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(PlatzColors.textMuted)
                        }
                    } header: {
                        Text("정보")
                    }
                    .listRowBackground(PlatzColors.surface)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .foregroundColor(PlatzColors.primary)
                }
            }
            .alert("진행도 초기화", isPresented: $showResetAlert) {
                Button("취소", role: .cancel) {}
                Button("초기화", role: .destructive) {
                    progressManager.resetProgress()
                }
            } message: {
                Text("정말 진행도를 초기화할까요? 이 작업은 되돌릴 수 없습니다.")
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                PlatzColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PlatzSpacing.xl) {
                        // Logo
                        VStack(spacing: PlatzSpacing.sm) {
                               ZStack {
                Circle()
                    .fill(PlatzColors.primary.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image("bedge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
                            
                            Text("platz")
                                .font(PlatzTypography.title1)
                                .foregroundColor(PlatzColors.primary)
                            
                            Text("v1.0.0")
                                .font(PlatzTypography.caption)
                                .foregroundColor(PlatzColors.textMuted)
                        }
                        .padding(.top, PlatzSpacing.xl)
                        
                        // Mission
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            Text("앱 소개")
                                .font(PlatzTypography.bodyBold)
                                .foregroundColor(PlatzColors.textPrimary)
                            
                            Text("platz는 독일에 관심 있는 학생들이 독일 문화, 역사, 정치, 행정을 편하게 읽고, 기초 독일어를 가볍게 시작할 수 있도록 만들어진 앱입니다.")
                                .font(PlatzTypography.body)
                                .foregroundColor(PlatzColors.textSecondary)
                        }
                        .padding(PlatzSpacing.md)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.large)
                        
                        // Features
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            Text("주요 기능")
                                .font(PlatzTypography.bodyBold)
                                .foregroundColor(PlatzColors.textPrimary)
                            
                            FeatureItem(icon: "quote.opening", text: "매일 바뀌는 독일어 명언")
                            FeatureItem(icon: "globe.europe.africa.fill", text: "독일 정보 위키 스타일 읽기")
                            FeatureItem(icon: "textformat.abc", text: "알파벳, 숫자, 문법 학습")
                            FeatureItem(icon: "bubble.left.and.bubble.right.fill", text: "실생활 회화 연습")
                            FeatureItem(icon: "questionmark.circle.fill", text: "퀴즈로 복습")
                        }
                        .padding(PlatzSpacing.md)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.large)
                        
                        // Credits
                        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
                            Text("감사의 글")
                                .font(PlatzTypography.bodyBold)
                                .foregroundColor(PlatzColors.textPrimary)
                            
                            Text("이 앱을 사용해 주셔서 감사합니다. 독일어 학습과 독일 문화 이해에 도움이 되기를 바랍니다.")
                                .font(PlatzTypography.caption)
                                .foregroundColor(PlatzColors.textSecondary)
                        }
                        .padding(PlatzSpacing.md)
                        .background(PlatzColors.surface)
                        .cornerRadius(PlatzRadius.large)
                        
                        // Creator
                        VStack(spacing: PlatzSpacing.sm) {
                            Text("Creator von Seunghwan Cho")
                                .font(PlatzTypography.title2)
                                .foregroundColor(PlatzColors.primary)
                            
                            Text("Entwickler Michael Ahn")
                                .font(PlatzTypography.title3)
                                .foregroundColor(PlatzColors.textPrimary)
                        }
                        .padding(.top, PlatzSpacing.xl)
                        
                        Spacer().frame(height: PlatzSpacing.xl)
                    }
                    .padding(PlatzSpacing.md)
                }
            }
            .navigationTitle("platz 소개")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .foregroundColor(PlatzColors.primary)
                }
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: PlatzSpacing.sm) {
            Image(systemName: icon)
                .foregroundColor(PlatzColors.primary)
                .frame(width: 24)
            Text(text)
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProgressManager())
}
