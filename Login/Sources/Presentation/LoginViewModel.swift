//
//  LoginViewModel.swift
//  Hambug
//
//  Created by 차상진 on 10/5/25.
//

import Foundation
import Managers
import LoginDomain

public final class LoginViewModel: @unchecked Sendable {
  private let useCase: LoginUseCase
  private let appStateManager: AppStateManager

  public init(useCase: LoginUseCase, appStateManager: AppStateManager) {
    self.useCase = useCase
    self.appStateManager = appStateManager
  }

  func createAppleLoginHandler() -> AppleLoginHandler {
    nonisolated(unsafe) let baseHandler = useCase.createAppleLoginHandler()

    // 기존 handler를 래핑하여 성공 시 completeLogin 호출
    return AppleLoginHandler(
      onRequest: baseHandler.onRequest,
      onCompletion: { [weak self] result in
        baseHandler.onCompletion(result)

        // 성공 시 앱 상태 전환
        if case .success = result {
          Task { @MainActor in
            self?.appStateManager.completeLogin()
          }
        }
      }
    )
  }

  func loginWithKakao() async throws {
    try await useCase.loginWithKakao()
    appStateManager.completeLogin()
  }
}
