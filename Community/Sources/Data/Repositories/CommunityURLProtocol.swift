//
//  CommunityURLProtocol.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import Foundation

public typealias Path = String
public typealias MockResponse = (statueCode: Int, data: Data?)

public final class CommunityURLProtocol: URLProtocol {
  public static var successMock: [Path: MockResponse] = [:]
  public static var failureErrors: [Path: Error] = [:]

  override public class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override public func startLoading() {
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
  override public func stopLoading() {
    
  }
}

public enum MocksessionError: Error {
  case notSupported
}
