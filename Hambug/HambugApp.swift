//
//  HambugApp.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

@main
struct HambugApp: App {
    @State private var appStateManager: AppStateManager = .init()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appStateManager)
        }
        
    }
}

fileprivate struct RootView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        Group {
            switch appStateManager.state {
            case .splash:
                SplashView()
                
            case .main:
                ContentView()
            }
        }
        .environment(appStateManager)
    }
}

