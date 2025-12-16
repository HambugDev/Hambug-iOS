//
//  TokenRefreshEndpoint.swift
//  Infrastructure
//
//  Created by 강동영 on 12/17/25.
//

import Foundation
import NetworkInterface

struct TokenRefreshEndpoint: Endpoint {
  let baseURL: String = NetworkServiceImpl.baseURL
  let path: String = "/api/v1/auth/refresh"
  let method: NetworkInterface.HTTPMethod = .POST
  let headers: [String : String]
  nonisolated(unsafe) let queryParameters: [String : Any] = [:]
  let body: Data? = nil
  
  init(headers: [String : String]) {
    self.headers = headers
  }
}
