//
//  FetchRecommendedBurgersUseCase.swift
//  HomeDomain
//
//  Created by Claude on 1/5/26.
//

import Foundation

public protocol FetchRecommendedBurgersUseCase {
    func execute() async throws -> [RecommendedBurger]
}
