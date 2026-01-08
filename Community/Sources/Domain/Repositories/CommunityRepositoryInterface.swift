//
//  CommunityRepositoryInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface

// MARK: - Community Repository Interface
public protocol CommunityRepositoryInterface {
    func fetchBoards() -> AnyPublisher<[Board], NetworkError>
}
