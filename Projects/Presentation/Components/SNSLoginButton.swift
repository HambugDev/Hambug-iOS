//
//  SNSLoginButton.swift
//  Hambug
//
//  Created by 차상진 on 9/25/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SNSLoginButton: View {
    let width = UIScreen.main.bounds.width * 0.8
    
    private let loginType: LoginType
    
    init(_ loginType: LoginType) {
        self.loginType = loginType


    }
    
    var body: some View {
        
        switch loginType {
        case .kakao(let kakaoAction):
            Button {
                kakaoAction()
            } label: {
                HStack {
                    Image(loginType.logoName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26)
                        
                    
                    Text("\(loginType.loginText) 로그인")
                        .foregroundColor(loginType.fontColor)
                        .pretendard(.title(.t2))
                }
                .frame(width: width, height: 50)
                .background(loginType.bgColor)
                .cornerRadius(14)
            }
        case .apple(let handler):
            SignInWithAppleButton(
                onRequest: handler.onRequest,
                onCompletion: handler.onCompletion
            )
            .frame(width: width, height: 50)
            .cornerRadius(14)
        }
    }
}
