//
//  HomeViewUseCase.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation

final class HomeViewUseCase {
    
    let repository: HomeViewRepository
    
    init(repository: HomeViewRepository) {
        self.repository = repository
    }
    
    func fetchPopularPosts() -> [PostModel] {
        self.repository.fetchPopularPosts()
    }
}
