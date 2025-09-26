//
//  AppState.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import Foundation

enum AppState: Equatable {
    case splash
    case onboarding
    case login
    case main
}

@Observable
class AppStateManager {
    var state: AppState = .splash
    
    var isOnboardingCompleted: Bool {
        UserDefaults.standard.bool(forKey: .Storage.hasSeenOnboarding)
    }
    
    func completeSplash() {
        if isOnboardingCompleted {
            state = .login
        } else {
            state = .onboarding
        }
    }
    
    // 온보딩 완료
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: .Storage.hasSeenOnboarding)
        state = .login
    }
}
