//
//  NetworkServiceInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import UIKit

// MARK: - Network Interface Protocol
public protocol NetworkServiceInterface: Sendable {
  func request<T: Decodable>(_ endpoint: any Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>

  func uploadMultipartWithJsonRequest<T: Decodable>(
    _ endpoint: any Endpoint,
    multiparts: [MultiPartFormType],
    responseType: T.Type
  ) -> AnyPublisher<T, NetworkError>
}
