//
//  SNSLoginButton.swift
//  Hambug
//
//  Created by 차상진 on 9/25/25.
//

import SwiftUI
import AuthenticationServices

import DesignSystem

// MARK: - LoginType, AppleLogionHandler
enum LoginType {
  case kakao(() -> Void)
  case apple(AppleLogionHandler)
}

struct AppleLogionHandler {
  var onRequest: (ASAuthorizationAppleIDRequest) -> Void
  var onCompletion: (Result<ASAuthorization, Error>) -> Void
}

// MARK: - SNSLoginButton
struct SNSLoginButton: View {
  private let loginType: LoginType
  
  init(_ loginType: LoginType) {
    self.loginType = loginType
  }
  
  var body: some View {

    switch loginType {
    case .kakao(let kakaoAction):
      KakaoLoginButton(onTap: kakaoAction)

    case .apple(let handler):
      SignInWithAppleButton(
        onRequest: handler.onRequest,
        onCompletion: handler.onCompletion
      )
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .cornerRadius(14)
    }
  }
}

// MARK: - KakaoLoginButton, Config
struct KakaoLoginButton: View {
  private let config: ButtonConfig
  private let onTap: () -> Void
  
  init(
    _ config: ButtonConfig = .kakao,
    onTap: @escaping () -> Void
  ) {
    self.config = config
    self.onTap = onTap
  }
  
  var body: some View {
    Button {
      onTap()
    } label: {
      HStack {
        Image(config.iconName)
          .resizable()
          .scaledToFit()
          .frame(width: 26)
        
        
        Text("\(config.title) 로그인")
          .foregroundColor(config.foregroundColor)
          .pretendard(.title(.t2))
      }
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(config.background)
      .cornerRadius(14)
    }
  }
}

struct ButtonConfig {
  let title: String
  let iconName: String
  let foregroundColor: Color
  let background: Color
  
  static let kakao = ButtonConfig(
    title: "카카오",
    iconName: "kakao",
    foregroundColor: .textG900,
    background: .kakaoBtnYellow
  )
}

