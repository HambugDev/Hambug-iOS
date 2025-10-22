//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI
import AuthenticationServices


struct LoginView: View {
    
    @Environment(AppStateManager.self) var appStateManager
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.bgYellow)
                .ignoresSafeArea()
            logoImage
            introView
        }
        
    }
    
    var introView: some View {
        
        let maxHeight = UIScreen.main.bounds.height
        
        return VStack {
            VStack(spacing: 6) {
                Text("안녕하세요.")
                    .pretendard(.heading(.h1))
                    .foregroundColor(.black)
                
                TextWithColoredSubstring(originalText: "햄버그입니다 :)", coloredSubstring: "햄버그")
                    .pretendard(.heading(.h1))
                
            }
            .offset(y: maxHeight / -7)
            
            
            VStack(spacing: 15) {
                Text("SNS 게정으로 간편 가입하기")
                    .pretendard(.body(.small))
                    .foregroundColor(.borderG400)
                
                VStack {
                    SNSLoginButton(.kakao {
                        viewModel.loginWithKakao {
                            appStateManager.state = .main
                        }
                    })
                    
                    SNSLoginButton(.apple(
                        viewModel.loginWithApple {
                            appStateManager.state = .main
                        }
                    ))
                }
                
            }
            .offset(y: maxHeight / 4)
        }
    }
    
    var logoImage: some View {
        VStack {
            Spacer()
            Image("hambug_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 170)
                
            Spacer()
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




//#Preview {
//    LoginView()
//}

