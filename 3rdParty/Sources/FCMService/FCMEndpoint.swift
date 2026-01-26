//
//  FCMEndpoint.swift
//  3rdParty
//
//  Created by 강동영 on 1/13/26.
//

import Foundation
import NetworkInterface

struct FCMEndpoint: Endpoint {
  let baseURL: String = NetworkConfig.baseURL
  let path: String = "/api/v1/fcm/tokens"
  
  let method: NetworkInterface.HTTPMethod = .POST
  
  var headers: [String : String] = [:]
  
  let queryParameters: [String : String] = [:]
  
  let body: Data?
  
  init(body: FCMRequest) {
    let encoder = JSONEncoder()
    self.body = try? encoder.encode(body)
  }
}

struct FCMRequest: Sendable, Encodable {
  let token: String
  let platform: String = "ios"
}
