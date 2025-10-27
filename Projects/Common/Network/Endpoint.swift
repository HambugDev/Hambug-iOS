//
//  Endpoint.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - HTTP Method
enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case DELETE = "DELETE"
  case PATCH = "PATCH"
}

// MARK: - Base Endpoint Protocol
protocol Endpoint {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryParameters: [String: Any] { get }
  var body: Data? { get }
}

extension Endpoint {
  func createURL() -> URL? {
    var urlComponents = URLComponents(string: baseURL.appending(path))
    var queryItems = [URLQueryItem]()
    
    queryParameters.forEach {
      queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
    }
    urlComponents?.queryItems = queryItems
    
    return urlComponents?.url
  }
  
  func createURLRequest() throws -> URLRequest {
    guard let url = createURL() else { throw NetworkError.invalidURL }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    var allHeaders: [String: String] = [:]
    headers.forEach { allHeaders.updateValue($1, forKey: $0) }
    
    return request
  }
}
