//
//  LoginRepository.swift
//  Hambug
//
//  Created by 차상진 on 10/9/25.
//

import Foundation
import Alamofire
import DataSources

final class LoginRepositoryImpl: LoginRepository {
  private let networkService: NetworkServiceInterface
  private let tokenStorage: TokenStorage

  init(networkService: NetworkServiceInterface, tokenStorage: TokenStorage) {
    self.networkService = networkService
    self.tokenStorage = tokenStorage
  }

  func login(request: SocialLoginAuthRequestDTO) async throws {
    let endpoint = AuthEndpoint.socialLogin(
      request: .init(provider: request.provider, accessToken: request.accessToken)
    )

    // NetworkService를 사용하여 API 호출
    let apiResponse: SuccessResponse<UserResponse> = try await networkService
      .request(
        endpoint,
        responseType: SuccessResponse<UserResponse>.self
      )
      .async()

    // 토큰을 Keychain에 저장
    try tokenStorage.save(
      accessToken: apiResponse.data.token.accessToken,
      refreshToken: apiResponse.data.token.refreshToken
    )
    print("✅ Tokens saved to Keychain")
  }
}

