//
//  NetworkServiceInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine

// MARK: - Network Interface Protocol
protocol NetworkServiceInterface {
  func request<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, NetworkError>
}

// MARK: - API Endpoint Protocol
protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Response Wrapper
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let code: Int?
}

struct ErrorResponse: Decodable {
  let message: String
}
