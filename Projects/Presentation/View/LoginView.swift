//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI

import KakaoSDKUser

struct LoginView: View {
    
    @Environment(AppStateManager.self) var appStateManager
    
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
                    SNSLoginButton(.kakao) {
                        loginWithKakao()
                    }
                    
                    SNSLoginButton(.apple) {
                        print("action()")
                    }
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
    
    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let token = token {
                    print("accessToken: \(token.accessToken)")
                    // 이때 서버로 액세스 토큰 전송
                    appStateManager.state = .main
                    
                } else {
                    print("error: \(error!)")
                }
            }
        } else {
            // 카카오 계정 웹뷰 로그인
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let token = token {
                    print("accessToken: \(token.accessToken)")
                } else {
                    print("error: \(error!)")
                }
            }
        }
    }
    
    
}


enum LoginType: String {
    case kakao = "카카오"
    case apple = "Apple"
    
    var logoName: String {
        self == .kakao ? "kakao" : "apple"
    }
    
    var fontColor: Color {
        self == .kakao ? .textG900 : .white
    }
    
    var bgColor: Color {
        self == .kakao ? .kakaoBtnYellow : .black
    }
}


#Preview {
    LoginView()
}
