//
//  Combine+Ext.swift
//  Hambug
//
//  Created by 강동영 on 12/12/25.
//

import Combine

// MARK: - Publisher to async/await extension
public extension Publisher where Output: Sendable {
  func async() async throws -> Output {
    try await withCheckedThrowingContinuation { continuation in
      var cancellable: AnyCancellable?

      cancellable = first()
        .sink { completion in
          switch completion {
          case .finished:
            break
          case .failure(let error):
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        } receiveValue: { value in
          continuation.resume(returning: value)
        }
    }
  }
}
