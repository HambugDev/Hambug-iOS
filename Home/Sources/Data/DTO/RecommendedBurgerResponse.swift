//
//  RecommendedBurgerResponse.swift
//  HomeData
//
//  Created by Claude on 1/5/26.
//

import Foundation
import HomeDomain

public struct RecommendedBurgerResponse: Decodable, Sendable {
    public let id: Int
    public let menuImage: String
    public let franchise: String
    public let menuName: String
    public let menuDescription: String
}

extension RecommendedBurgerResponse {
    public func toDomain() -> RecommendedBurger {
        return RecommendedBurger(
            id: id,
            menuImage: menuImage,
            franchise: franchise,
            menuName: menuName,
            menuDescription: menuDescription
        )
    }
}
