//
//  LoginView.swift
//  Hambug
//
//  Created by 차상진 on 9/24/25.
//

import SwiftUI

import AuthenticationServices
import KakaoSDKUser
import Alamofire


struct LoginView: View {
    
    @Environment(AppStateManager.self) var appStateManager
    
    let viewModel = LoginViewModel()
    
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


class LoginViewModel {
    
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
    LoginView()
}

enum Endpoint {
    case auth
}

extension Endpoint {
    var urlString: String {
        switch self {
        case .auth:
            return .makeForEndPoint("/auth/me")
        }
    }
}

extension String {
    static let baseURL = "https://hambug.p-e.kr/api/v1"
    
    static func makeForEndPoint(_ endPoint: String) -> String {
        baseURL + endPoint
    }
}

