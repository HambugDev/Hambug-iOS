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
//import KakaoSDKAuth

class LoginViewModel {
    
    let useCase: LoginUseCase
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    
    func loginWithApple(
        onSccuess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) -> AppleLogionHandler {
        self.useCase.loginWithApple(onSccuess: onSccuess, onFailure: onFailure)
    }

    func loginWithKakao(
        onSccuess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        self.useCase.loginWithKakao(onSccuess: onSccuess, onFailure: onFailure)
    }
    
   
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        self.useCase.fetchUserProfile(accessToken: accessToken, completion: completion)
    }
}




