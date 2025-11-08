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
    
    // 사용자 기기에 로그인이 되어있는 상태인지 체크
    public var isLoginCompleted: Bool {
        UserDefaultsManager.shared.loadUserData() == nil ? false : true
    }

    public func completeSplash() {
        if isOnboardingCompleted {
            state = isLoginCompleted ? .main : .login
        } else {
            state = .onboarding
        }
    }
    
    // 온보딩 완료
    public func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: .Storage.hasSeenOnboarding)
        state = isLoginCompleted ? .main : .login
    }
    
    public init() {}
}
