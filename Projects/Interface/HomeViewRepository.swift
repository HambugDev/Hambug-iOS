//
//  HomeViewRepository.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation

protocol HomeViewRepository {
    func fetchPopularPosts() -> [PostModel]
}

class DummyHomeViewRepositoryImpl: HomeViewRepository {
    
    func fetchPopularPosts() -> [PostModel] {
        return [
            PostCodableItem(
                id: 1,
                title: "글 제목입니다.1",
                content: "글 내용입니다.1",
                createdAt: Date(),
                updatedAt: Date()
            ),
            PostCodableItem(
                id: 2,
                title: "글 제목입니다.2",
                content: "글 내용입니다.2",
                createdAt: Date(),
                updatedAt: Date()
            ),
            PostCodableItem(
                id: 3,
                title: "글 제목입니다.3",
                content: "글 내용입니다.3",
                createdAt: Date(),
                updatedAt: Date()
            ),
            PostCodableItem(
                id: 4,
                title: "글 제목입니다.4",
                content: "글 내용입니다.4",
                createdAt: Date(),
                updatedAt: Date()
            ),
            PostCodableItem(
                id: 5,
                title: "글 제목입니다.5",
                content: "글 내용입니다.5",
                createdAt: Date(),
                updatedAt: Date()
            )
        ].map {
            PostModel(postCodableItem: $0)
        }
    }
}
