//
//  AppState.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import Foundation
import DataSources

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
  
  private let tokenStorage: TokenStorage
  private var udManager: UserDefaultsManager
  
  public init(
    tokenStorage: TokenStorage,
    udManager: UserDefaultsManager
  ) {
    self.tokenStorage = tokenStorage
    self.udManager = udManager
  }
  
  public var isOnboardingCompleted: Bool {
    udManager.isOnboardingCompleted
  }
  
  // Keychain으로 로그인 상태 확인
  public var isLoginCompleted: Bool {
    do {
      let hasLoggedInBefore = try tokenStorage.exists(.accessToken)
      return hasLoggedInBefore && isOnboardingCompleted
    } catch {
      print("⚠️ Failed to check login status: \(error)")
      return false
    }
  }
  
  public func completeSplash() {
    if isLoginCompleted {
      state = .main
    } else if isOnboardingCompleted {
      state = .main
    } else {
      state = .onboarding
    }
  }
  
  // 온보딩 완료
  public func completeOnboarding() {
    udManager.isOnboardingCompleted = true
    state = .login
  }
  
  // 로그인 완료
  public func completeLogin() {
    state = .main
  }
  
  // 로그아웃
  public func logout() {
    do {
      try tokenStorage.clear(.accessToken)
      try tokenStorage.clear(.refreshToken)
      try tokenStorage.clear(.fcmToken)
      UserDefaultsManager.shared.clearAll()
      state = .login
    } catch {
      print("⚠️ Failed to logout: \(error)")
      state = .login
    }
  }
}
