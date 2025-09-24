//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
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
                TextWithColoredSubstring(originalText: "햄버그입니다 :)", coloredSubstring: "햄버그")
                    .pretendard(.heading(.h1))
                
            }
            .offset(y: maxHeight / -5)
            
            
            VStack {
                Text("SNS 게정으로 간편 가입하기")
                    .pretendard(.body(.small))
                    .foregroundColor(.secondary)
                
                
                
            }
            .offset(y: maxHeight / 6)
        }
    }
    
    var logoImage: some View {
        VStack {
            Spacer()
            Image("hambug_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                
            Spacer()
        }
    }
}


#Preview {
    LoginView()
}
