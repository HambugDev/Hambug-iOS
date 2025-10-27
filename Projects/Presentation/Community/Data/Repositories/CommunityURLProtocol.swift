//
//  CommunityURLProtocol.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import Foundation

typealias Path = String
typealias MockResponse = (statueCode: Int, data: Data?)

final class CommunityURLProtocol: URLProtocol {
  static var successMock: [Path: MockResponse] = [:]
  static var failureErrors: [Path: Error] = [:]
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    if let url = request.url {
      let fullPath = url.path + (url.query.map { "?\($0)" } ?? "")
      if let mockResponse = CommunityURLProtocol.successMock[fullPath] {
        client?.urlProtocol(self, didReceive: HTTPURLResponse(
          url: request.url!,
          statusCode: mockResponse.statueCode,
          httpVersion: nil,
          headerFields: nil)!, cacheStoragePolicy: .notAllowed
        )
        mockResponse.data.map { client?.urlProtocol(self, didLoad: $0) }
      } else if let error = CommunityURLProtocol.failureErrors[fullPath] {
        client?.urlProtocol(self, didFailWithError: error)
      } else {
        client?.urlProtocol(self, didFailWithError: MocksessionError.notSupported)
      }
    }
    
    client?.urlProtocolDidFinishLoading(self)
  }
  
  // override 하지않으면 크래시가 남
  override func stopLoading() {
    
  }
}

enum MocksessionError: Error {
  case notSupported
}
