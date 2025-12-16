//
//  AuthInterceptor.swift
//  Hambug
//
//  Created by 강동영 on 12/16/25.
//


import Foundation
import DataSources

import Alamofire

// MARK: - Auth Interceptor
final class AuthInterceptor: RequestInterceptor {
  private let tokenManager: TokenStorage
  
  init(tokenManager: TokenStorage) {
    self.tokenManager = tokenManager
  }
  
  private actor RefreshCoordinator {
    private var refreshTask: Task<Bool, Never>?
    
    func refresh(with refreshTokens: @escaping () async -> Bool) async -> Bool {
      if let existingTask = refreshTask {
        return await existingTask.value
      }
      
      let task = Task {
        await refreshTokens()
      }
      
      refreshTask = task
      let result = await task.value
      refreshTask = nil
      
      return result
    }
    
  }
  
  private let coordinator = RefreshCoordinator()
  
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    var urlRequest = urlRequest
    
    let (access, refresh) = tokenManager.load()
    if let accessToken = access {
      urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    if let refreshToken = refresh {
      urlRequest.setValue(refreshToken, forHTTPHeaderField: "RefreshToken")
    }
    
    completion(.success(urlRequest))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: any Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }
    
    
    Task {
      let success = await coordinator.refresh { [weak self] in
        guard let self = self else { return false }
        return await self.refreshTokens()
      }
      
      if success {
        completion(.retry)
      } else {
        completion(.doNotRetry)
        handleLogout()
      }
    }
    
  }
  
  private func refreshTokens() async -> Bool {
    let tokens = tokenManager.load()
    guard let accessToken = tokens.accessToken,
          let refreshToken = tokens.refreshToken else {
      return false
    }
    
    guard let endpoint = try? AuthEndpoint.refresh(info: .init(accessToken: accessToken, refreshToken: refreshToken)).createURLRequest() else {
      return false
    }
    
    do {
      let tokenResponse = try await AF.request(endpoint)
        .validate()
        .serializingDecodable(SuccessResponse<TokenResponse>.self)
        .value
      
      try? tokenManager.save(accessToken: tokenResponse.data.accessToken, refreshToken: nil)
      
      return true
    } catch {
      return false
    }
  }
  
  private func handleLogout() {
    try? tokenManager.clear()
    NotificationCenter.default.post(name: .userDidLogout, object: nil)
  }
  
}

extension NSNotification.Name {
  static let userDidLogout = NSNotification.Name("userDidLogout")
}


