//
//  LoginRepository.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


protocol LoginRepository {
  func fetchUserProfile(accessToken: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
}