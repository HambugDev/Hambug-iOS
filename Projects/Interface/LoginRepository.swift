//
//  LoginRepository.swift
//  Hambug
//
//  Created by 차상진 on 10/9/25.
//

import Foundation
import Alamofire

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
                    print(profile)
                    
                    completion(.success(profile))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
