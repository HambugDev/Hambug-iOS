//
//  HomeViewUseCaseImpl.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


final class HomeViewUseCaseImpl: HomeViewUseCase {
  
  let repository: HomeViewRepository
  
  init(repository: HomeViewRepository) {
    self.repository = repository
  }
  
  func fetchPopularPosts() -> [PostModel] {
    self.repository.fetchPopularPosts()
  }
}
