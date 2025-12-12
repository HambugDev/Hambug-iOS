//
//  LoginRepository.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


protocol LoginRepository {
  func login(request: SocialLoginAuthRequestDTO) async throws
}
