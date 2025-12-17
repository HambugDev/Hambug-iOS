//
//  LoginUseCaseImpl.swift
//  Hambug
//
//  Created by 차상진 on 10/7/25.
//  Moved to Domain by Claude on 12/16/25
//

import Foundation
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

public final class LoginUseCaseImpl: LoginUseCase, @unchecked Sendable {
  private let repository: LoginRepository

  public init(repository: LoginRepository) {
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
      let loginHandler: (OAuthToken?, Error?) -> Void = { token, error in
        if let error = error {
          print("Kakao login error: \(error)")
          continuation.resume(throwing: error)
        } else if let token = token {
          continuation.resume(returning: token.accessToken)
        }
      }

      if UserApi.isKakaoTalkLoginAvailable() {
        // 카카오톡 앱으로 로그인
        UserApi.shared.loginWithKakaoTalk(completion: loginHandler)
      } else {
        // 카카오 계정 웹뷰 로그인
        UserApi.shared.loginWithKakaoAccount(completion: loginHandler)
      }
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
