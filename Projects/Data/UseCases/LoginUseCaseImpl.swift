//
//  LoginUseCaseImpl.swift
//  Hambug
//
//  Created by 차상진 on 10/7/25.
//

import Foundation
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

final class LoginUseCaseImpl: LoginUseCase {
  private let repository: LoginRepository

  init(repository: LoginRepository) {
    self.repository = repository
  }

  func createAppleLoginHandler() -> AppleLogionHandler {
    AppleLogionHandler(
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
                // Repository가 토큰 저장 처리 (async/await)
                try await self.repository.login(
                  request: .init(provider: .apple, accessToken: tokenString)
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

  func loginWithKakao() async throws {
    let token: OAuthToken = try await withCheckedThrowingContinuation { continuation in
      let loginHandler: (OAuthToken?, Error?) -> Void = { token, error in
        if let error = error {
          print("Kakao login error: \(error)")
          continuation.resume(throwing: error)
        } else if let token = token {
          continuation.resume(returning: token)
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

    print("Kakao accessToken: \(token.accessToken)")

    // Repository가 토큰 저장 처리 (async/await)
    try await repository.login(
      request: .init(provider: .kakao, accessToken: token.accessToken)
    )
    print("✅ Login successful - tokens saved to Keychain")
  }
}
