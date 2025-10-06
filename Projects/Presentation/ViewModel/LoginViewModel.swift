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
                        completion()
                    }
                case .failure(let error):
                    print("Apple login error: \(error)")
                }
            }
        )
    }

    func loginWithKakao(completion: @escaping () -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let token = token {
                    print("accessToken: \(token.accessToken)")
                    // 이때 서버로 액세스 토큰 전송
                    self.fetchUserProfile(accessToken: token.accessToken) { result in
                        switch result {
                        case .success(let profile):
                            print(profile)
                            completion()
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                } else {
                    print("error: \(error!)")
                }
            }
        } else {
            // 카카오 계정 웹뷰 로그인
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let token = token {
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
                } else {
                    print("error: \(error!)")
                }
            }
        }
    }
    
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        self.useCase.fetchUserProfile(accessToken: accessToken, completion: completion)
    }
}




protocol LoginRepository {
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
}

class LoginRepositoryImpl: LoginRepository {
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, any Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)"
        ]
        
        AF.request(Endpoint.auth.urlString, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let profile):
                    // TODO: 여기서 유저 데이터 저장하기
                    print(profile)
                    
                    completion(.success(profile))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
