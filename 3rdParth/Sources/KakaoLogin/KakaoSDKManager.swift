//
//  KakaoSDKManager.swift
//  Hambug
//
//  Created by 강동영 on 12/17/25.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


public final class KakaoSDKManager {
  nonisolated(unsafe)
  public static let shared: KakaoSDKManager = .init()
  
  private init() {}
  
  // MARK: - KakaoSDKCommon
  public func regist(appKey: String) {
    KakaoSDK.initSDK(appKey: appKey)
  }
  
  // MARK: - KakaoSDKAuth
  @MainActor
  public func authCallback(with url: URL) {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      _ = AuthController.handleOpenUrl(url: url)
    }
  }
  
  // MARK: - KakaoSDKUser
  public func handle(_ continuation: CheckedContinuation<String, Error>) {
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
}
