//
//  CommunityRepositoryInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine

// MARK: - Community Repository Interface
protocol CommunityRepositoryInterface {
    func fetchBoards() -> AnyPublisher<[Board], NetworkError>
}
