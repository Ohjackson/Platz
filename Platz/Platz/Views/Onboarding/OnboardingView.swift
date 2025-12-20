//
//  OnboardingView.swift
//  Platz
//
//  온보딩 화면 (3페이지)
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @State private var currentPage = 0
    @State private var notificationEnabled = true
    
    var body: some View {
        ZStack {
            PlatzColors.background
                .ignoresSafeArea()
            
            VStack {
                // Page Content
                TabView(selection: $currentPage) {
                    // Page 1: Welcome
                    OnboardingPage1()
                        .tag(0)
                    
                    // Page 2: Features
                    OnboardingPage2()
                        .tag(1)
                    
                    // Page 3: Quote & Start
                    OnboardingPage3(
                        notificationEnabled: $notificationEnabled,
                        onStart: completeOnboarding
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page Indicator & Button
                VStack(spacing: PlatzSpacing.lg) {
                    // Page indicators
                    HStack(spacing: PlatzSpacing.xs) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? PlatzColors.primary : PlatzColors.border)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    // Next/Start Button
                    if currentPage < 2 {
                        Button("다음") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
                    }
                }
                .padding(.horizontal, PlatzSpacing.lg)
                .padding(.bottom, PlatzSpacing.xl)
            }
        }
    }
    
    private func completeOnboarding() {
        progressManager.hasCompletedOnboarding = true
    }
}

// MARK: - Page 1: Welcome
struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: PlatzSpacing.xl) {
            Spacer()
            
            // Logo/Icon
            ZStack {
                Circle()
                    .fill(PlatzColors.primary.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image("bedge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
            
            // Title
            VStack(spacing: PlatzSpacing.sm) {
                Text("Hallo!")
                    .font(PlatzTypography.largeTitle)
                    .foregroundColor(PlatzColors.primary)
                
                Text("platz입니다")
                    .font(PlatzTypography.title2)
                    .foregroundColor(PlatzColors.textPrimary)
            }
            
            // Description
            Text("독일을 읽고,\n가볍게 독일어를 시작해요.")
                .font(PlatzTypography.bodyLarge)
                .foregroundColor(PlatzColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
        .padding(PlatzSpacing.lg)
    }
}

// MARK: - Page 2: Features
struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: PlatzSpacing.xl) {
            Spacer()
            
            Text("두 가지 경험")
                .font(PlatzTypography.title2)
                .foregroundColor(PlatzColors.textPrimary)
            
            // Feature Cards
            VStack(spacing: PlatzSpacing.md) {
                FeatureCard(
                    icon: "globe.europe.africa.fill",
                    title: "독일",
                    description: "문화 · 정치 · 행정 · 상식\n위키처럼 편하게 읽기",
                    color: PlatzColors.primary
                )
                
                FeatureCard(
                    icon: "book.fill",
                    title: "학습",
                    description: "알파벳 · 숫자 · 문법 · 회화\n짧은 퀴즈로 마무리",
                    color: PlatzColors.link
                )
            }
            
            // Offline badge
            HStack(spacing: PlatzSpacing.xs) {
                Image(systemName: "wifi.slash")
                    .foregroundColor(PlatzColors.textMuted)
                Text("오프라인에서도 사용 가능")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
            }
            .padding(.top, PlatzSpacing.md)
            
            Spacer()
            Spacer()
        }
        .padding(PlatzSpacing.lg)
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: PlatzSpacing.md) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: PlatzRadius.medium)
                    .fill(color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: PlatzSpacing.xxs) {
                Text(title)
                    .font(PlatzTypography.title3)
                    .foregroundColor(PlatzColors.textPrimary)
                
                Text(description)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textSecondary)
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

// MARK: - Page 3: Quote & Notification
struct OnboardingPage3: View {
    @Binding var notificationEnabled: Bool
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: PlatzSpacing.xl) {
            Spacer()
            
            // Quote Icon
            Image(systemName: "quote.opening")
                .font(.system(size: 48))
                .foregroundColor(PlatzColors.primary)
            
            // Title
            VStack(spacing: PlatzSpacing.sm) {
                Text("매일 바뀌는")
                    .font(PlatzTypography.body)
                    .foregroundColor(PlatzColors.textSecondary)
                
                Text("독일어 명언으로 시작")
                    .font(PlatzTypography.title2)
                    .foregroundColor(PlatzColors.textPrimary)
            }
            
            // Sample Quote
            VStack(spacing: PlatzSpacing.xs) {
                Text("\"Übung macht den Meister.\"")
                    .font(PlatzTypography.quoteSmall)
                    .foregroundColor(PlatzColors.textPrimary)
                
                Text("연습이 달인을 만든다")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textSecondary)
            }
            .padding(PlatzSpacing.md)
            .background(PlatzColors.surfaceRaised)
            .cornerRadius(PlatzRadius.medium)
            
            // Notification Toggle (Optional)
            // Toggle(isOn: $notificationEnabled) {
            //     HStack {
            //         Image(systemName: "bell.fill")
            //             .foregroundColor(PlatzColors.primary)
            //         Text("명언 알림 받기")
            //             .font(PlatzTypography.body)
            //             .foregroundColor(PlatzColors.textPrimary)
            //     }
            // }
            // .toggleStyle(SwitchToggleStyle(tint: PlatzColors.primary))
            // .padding(PlatzSpacing.md)
            // .background(PlatzColors.surface)
            // .cornerRadius(PlatzRadius.medium)
            
            Spacer()
            
            // Start Button
            Button("platz 들어가기") {
                onStart()
            }
            .buttonStyle(PlatzPrimaryButtonStyle(isFullWidth: true))
            
            Spacer()
        }
        .padding(PlatzSpacing.lg)
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
        .environmentObject(ProgressManager())
}

