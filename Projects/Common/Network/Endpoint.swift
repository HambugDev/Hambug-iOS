//
//  Endpoint.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Base Endpoint Protocol
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
}

// MARK: - Request Protocol
protocol APIRequest: Codable {
    associatedtype Response: Codable
    var endpoint: any Endpoint { get }
}
