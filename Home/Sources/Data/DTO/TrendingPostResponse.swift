//
//  TrendingPostResponse.swift
//  HomeData
//
//  Created by 강동영 on 1/5/26.
//

import Foundation
import HomeDomain

public struct TrendingPostResponse: Decodable, Sendable {
    public let id: Int
    public let title: String
    public let content: String
    public let category: String
    public let imageUrls: [String]
    public let authorNickname: String
    public let authorId: Int
    public let createdAt: String  // ISO8601 문자열
    public let updatedAt: String  // ISO8601 문자열
    public let viewCount: Int
    public let likeCount: Int
    public let commentCount: Int
    public let isLiked: Bool
}

extension TrendingPostResponse {
    public func toDomain() -> TrendingPost {
        let formatter = ISO8601DateFormatter()

        return TrendingPost(
            id: id,
            title: title,
            content: content,
            category: category,
            imageUrls: imageUrls,
            authorNickname: authorNickname,
            authorId: authorId,
            createdAt: formatter.date(from: createdAt) ?? Date(),
            updatedAt: formatter.date(from: updatedAt) ?? Date(),
            viewCount: viewCount,
            likeCount: likeCount,
            commentCount: commentCount,
            isLiked: isLiked
        )
    }
}
