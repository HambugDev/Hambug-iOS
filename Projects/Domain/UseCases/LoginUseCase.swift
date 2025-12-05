//
//  LoginUseCase.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


protocol LoginUseCase {
  func loginWithKakao(
    onSccuess: @escaping () -> Void,
    onFailure: @escaping () -> Void
  )
  
  func loginWithApple(
    onSccuess: @escaping () -> Void,
    onFailure: @escaping () -> Void
  ) -> AppleLogionHandler
  
  func fetchUserProfile(
    accessToken: String,
    completion: @escaping (Result<UserResponse, Error>) -> Void
  )
}
