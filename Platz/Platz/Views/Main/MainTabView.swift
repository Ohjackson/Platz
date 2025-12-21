//
//  MainTabView.swift
//  Platz
//
//  메인 탭 네비게이션
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var learnNavigationId = UUID() // For resetting navigation
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background - extends to edges
            PlatzColors.background
                .ignoresSafeArea()
            
            // Tab Content - each tab has its own NavigationStack
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    GermanyView()
                case 2:
                    LearnView(navigationId: $learnNavigationId)
                default:
                    HomeView()
                }
            }
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab, onSameTabTap: { tab in
                if tab == 2 {
                    learnNavigationId = UUID()
                }
            })
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var onSameTabTap: (Int) -> Void
    
    var body: some View {
        HStack {
            TabBarItem(
                icon: "house.fill",
                title: "홈",
                isSelected: selectedTab == 0
            ) {
                if selectedTab == 0 { onSameTabTap(0) }
                else { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = 0 } }
            }
            
            TabBarItem(
                icon: "globe.europe.africa.fill",
                title: "독일",
                isSelected: selectedTab == 1
            ) {
                if selectedTab == 1 { onSameTabTap(1) }
                else { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = 1 } }
            }
            
            TabBarItem(
                icon: "book.fill",
                title: "학습",
                isSelected: selectedTab == 2
            ) {
                if selectedTab == 2 { onSameTabTap(2) }
                else { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = 2 } }
            }
        }
        .padding(.horizontal, PlatzSpacing.lg)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 0) // Floating slightly above home indicator if needed, or stick to bottom safe area naturally with padding
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? PlatzColors.navActive : PlatzColors.navInactive)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isSelected ? PlatzColors.navActive : PlatzColors.navInactive)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
}
