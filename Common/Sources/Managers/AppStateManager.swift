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
    // 디버깅용 - 실제로는 제거하거나 조건부로 설정
     UserDefaults.standard.set(false, forKey: .Storage.hasSeenOnboarding)
  }
  
  public var isOnboardingCompleted: Bool {
    udManager.isOnboardingCompleted
  }
  
  // Keychain으로 로그인 상태 확인
  public var isLoginCompleted: Bool {
    do {
      return try tokenStorage.exists()
    } catch {
      print("⚠️ Failed to check login status: \(error)")
      return false
    }
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
    udManager.isOnboardingCompleted = true
    state = isLoginCompleted ? .main : .login
  }
  
  // 로그인 완료
  public func completeLogin() {
    print(#function)
    state = .main
  }
  
  // 로그아웃 (선택사항 - 나중에 구현 예정이지만 미리 추가)
  public func logout() {
    do {
      try tokenStorage.clear()
      state = .login
    } catch {
      print("⚠️ Failed to logout: \(error)")
      state = .login
    }
  }
}
