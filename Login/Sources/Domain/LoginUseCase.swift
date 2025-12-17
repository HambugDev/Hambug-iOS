//
//  LoginUseCase.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//

public protocol LoginUseCase {
  func loginWithKakao() async throws

  func createAppleLoginHandler() -> AppleLoginHandler
}
