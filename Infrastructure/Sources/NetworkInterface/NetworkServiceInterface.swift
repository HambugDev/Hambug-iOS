//
//  NetworkServiceInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine

// MARK: - Network Interface Protocol
public protocol NetworkServiceInterface {
  func request<T: Decodable>(_ endpoint: any Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>
}
