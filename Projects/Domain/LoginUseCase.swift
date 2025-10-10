//
//  LoginUseCase.swift
//  Hambug
//
//  Created by 차상진 on 10/7/25.
//

import Foundation
import AuthenticationServices

class LoginUseCase {
    let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        self.repository.fetchUserProfile(accessToken: accessToken, completion: completion)
    }
    
    
}
