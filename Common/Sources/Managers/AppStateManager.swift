//
//  AppState.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import Foundation

public enum AppState: Equatable {
    case splash
    case onboarding
    case login
    case main
}


@available(iOS, introduced: 17.0)
@Observable
public final class AppStateManager {
    private var state: AppState = .splash
    public var currentState: AppState { state }
    
    public var isOnboardingCompleted: Bool {
        UserDefaults.standard.bool(forKey: .Storage.hasSeenOnboarding)
    }
    
    public func completeSplash() {
        if isOnboardingCompleted {
            state = .login
        } else {
            state = .onboarding
        }
    }
    
    // 온보딩 완료
    public func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: .Storage.hasSeenOnboarding)
        state = .login
    }
    
    public init() {}
}
