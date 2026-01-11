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

  func uploadMultipart<T: Decodable>(
    _ endpoint: any Endpoint,
    images: [UIImage],
    responseType: T.Type
  ) -> AnyPublisher<T, NetworkError>
}
