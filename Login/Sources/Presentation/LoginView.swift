//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI
import DesignSystem
import Managers

public struct LoginView: View {
  @State var failureText: String = ""

  private let viewModel: LoginViewModel

  public init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
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
          Task {
            do {
              try await viewModel.loginWithKakao()
            } catch {
              failureText = "로그인 실패!"
              print("❌ Kakao login error: \(error)")
            }
          }
        })

        SNSLoginButton(.apple(
          viewModel.createAppleLoginHandler()
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


