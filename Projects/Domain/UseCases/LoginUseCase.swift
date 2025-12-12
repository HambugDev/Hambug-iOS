//
//  LoginUseCase.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


protocol LoginUseCase {
  func loginWithKakao() async throws

  func createAppleLoginHandler() -> AppleLogionHandler
}
