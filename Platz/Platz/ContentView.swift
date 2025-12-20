//
//  ContentView.swift
//  Platz
//
//  루트 뷰 - 온보딩 또는 메인 화면 표시
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        Group {
            if progressManager.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
        .environmentObject(ProgressManager())
}
