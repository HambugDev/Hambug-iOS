//
//  LoginViewModel.swift
//  Hambug
//
//  Created by 차상진 on 10/5/25.
//

import SwiftUI
import Foundation
import Alamofire
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

class LoginViewModel {
    
    let useCase: LoginUseCase
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    func loginWithApple(completion: @escaping () -> Void) -> AppleLogionHandler {
        AppleLogionHandler(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                       let identityToken = appleIDCredential.identityToken,
                       let tokenString = String(data: identityToken, encoding: .utf8) {
                        
                        print("Apple identity token: \(tokenString)")
                        // 이 토큰을 서버로 전송해서 로그인 처리
                        self.fetchUserProfile(accessToken: tokenString) { result in
                            switch result {
                            case .success(let profile):
                                print(profile)
                                completion()
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                case .failure(let error):
                    print("Apple login error: \(error)")
                }
            }
        )
    }

    func loginWithKakao(completion: @escaping () -> Void) {
        
        let loginHandler: (OAuthToken?, Error?) -> Void = { token, error in
            guard let token = token else {
                if let error = error { print("error: \(error)") }
                return
            }
            print("accessToken: \(token.accessToken)")
            self.fetchUserProfile(accessToken: token.accessToken) { result in
                switch result {
                case .success(let profile):
                    print(profile)
                    completion()
                case .failure(let error):
                    print(error)
                }
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
    
   
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        self.useCase.fetchUserProfile(accessToken: accessToken, completion: completion)
    }
}




