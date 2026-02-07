//
//  LoginUseCaseImpl.swift
//  Hambug
//
//  Created by 강동영 on 12/16/25
//

import Foundation
import AuthenticationServices
import KakaoLogin

public final class LoginUseCaseImpl: LoginUseCase, @unchecked Sendable {
  private let repository: LoginRepository
  private let kakaoManager: KakaoSDKManager
  
  public init(repository: LoginRepository) {
    self.kakaoManager = KakaoSDKManager.shared
    self.repository = repository
  }

  public func createAppleLoginHandler() -> AppleLoginHandler {
    AppleLoginHandler(
      onRequest: { request in
        request.requestedScopes = [.fullName, .email]
      },
      onCompletion: { [weak self] result in
        guard let self = self else { return }

        Task {
          switch result {
          case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {

              print("Apple identity token: \(tokenString)")

              do {
                // Use Domain model
                try await self.repository.login(
                  request: SocialLoginRequest(
                    provider: .apple,
                    accessToken: tokenString
                  )
                )
                print("✅ Apple login successful - tokens saved to Keychain")
              } catch {
                print("❌ Apple login failed: \(error)")
              }
            }
          case .failure(let error):
            print("❌ Apple login error: \(error)")
          }
        }
      }
    )
  }

  public func loginWithKakao() async throws {
    let accessToken: String = try await withCheckedThrowingContinuation { continuation in
      kakaoManager.handle(continuation)
    }

    print("Kakao accessToken: \(accessToken)")

    // Use Domain model
    try await repository.login(
      request: SocialLoginRequest(
        provider: .kakao,
        accessToken: accessToken
      )
    )
    print("✅ Login successful - tokens saved to Keychain")
  }
}
