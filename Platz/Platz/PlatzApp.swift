//
//  PlatzApp.swift
//  Platz
//
//  독일 문화/역사/정치/행정 정보 + 기초 독일어 학습 앱
//

import SwiftUI

@main
struct PlatzApp: App {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var progressManager = ProgressManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(progressManager)
                .preferredColorScheme(.dark)
        }
    }
}
