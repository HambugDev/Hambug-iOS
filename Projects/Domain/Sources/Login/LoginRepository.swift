//
//  LoginRepository.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//

public protocol LoginRepository {
  func login(request: SocialLoginRequest) async throws
}
