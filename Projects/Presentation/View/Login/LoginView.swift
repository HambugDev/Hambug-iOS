//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI
import AuthenticationServices
import DesignSystem
import Managers

struct LoginView: View {
  @Environment(AppStateManager.self) var appStateManager
  @State var failureText: String = ""
  
  private let viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      Color(.white)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        // 상단 여백
        Spacer()
          .frame(maxHeight: 147)
        
        // 인사말
        helloText
        
        // 인사말과 로고 사이 여백
        Spacer(minLength: 0)
          .frame(maxHeight: 33)
        
        // 로고
        logoImageView
        
        // 로고와 버튼 사이 여백
        Spacer(minLength: 0)
          .frame(maxHeight: 100)
        
        // 로그인 버튼 영역
        loginButtons
        
        // 하단 여백
        Spacer()
          .frame(minHeight: 51, maxHeight: 80)
      }
    }
  }
  
  private var helloText: some View {
    VStack(spacing: 6) {
      Text(verbatim: .LocalizedString.Login.hello)
        .pretendard(.heading(.h1))
        .foregroundColor(.black)
      
      HStack(spacing: 0) {
        Text(verbatim: .LocalizedString.Login.hambug)
          .foregroundColor(Color.primaryHambugRed)
        Text(verbatim: .LocalizedString.Login.hambugSuffix)
          .foregroundColor(.black)
      }
      .pretendard(.heading(.h1))
    }
  }
  
  private var logoImageView: some View {
    Image("hambug_logo")
      .resizable()
      .scaledToFit()
      .frame(width: 160, height: 160)
  }
  
  private var loginButtons: some View {
    VStack(spacing: 16) {
      Text(verbatim: .LocalizedString.Login.descriptionOfSNS)
        .pretendard(.body(.small))
        .foregroundColor(.borderG400)
      
      VStack(spacing: 10) {
        SNSLoginButton(.kakao {
          viewModel.loginWithKakao(
            onSccuess: {
              // TODO: 성공처리
            },
            onFailure: {
              failureText = "로그인 실패!"
            }
          )
        })
        
        SNSLoginButton(.apple(
          viewModel.loginWithApple(
            onSccuess: {
              // TODO: 성공처리
            },
            onFailure: {
              failureText = "로그인 실패!"
            }
          )
        ))
        
        if !failureText.isEmpty {
          Text(failureText)
            .pretendard(.body(.bEmphasis))
            .foregroundColor(.primaryHambugRed)
        }
      }
      .padding(.horizontal, 18)
    }
  }
  
}

struct AppleLogionHandler {
  var onRequest: (ASAuthorizationAppleIDRequest) -> Void
  var onCompletion: (Result<ASAuthorization, Error>) -> Void
}

enum LoginType {
  case kakao(() -> Void)
  case apple(AppleLogionHandler)
  
  var loginText: String {
    switch self {
    case .kakao: return "카카오"
    case .apple: return "Apple"
    }
  }
  
  var logoName: String {
    switch self {
    case .kakao: return "kakao"
    case .apple: return "apple"
    }
  }
  
  var fontColor: Color {
    switch self {
    case .kakao: return .textG900
    case .apple: return .white
    }
  }
  
  var bgColor: Color {
    switch self {
    case .kakao: return .kakaoBtnYellow
    case .apple: return .black
    }
  }
}




#Preview {
  let appStateManager: AppStateManager = .init()
  LoginView(viewModel: DIContainer.shared.loginViewModel)
      .environment(appStateManager)
}

