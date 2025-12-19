//
//  HomeViewUseCaseImpl.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//


public final class HomeViewUseCaseImpl: HomeViewUseCase {

  let repository: HomeViewRepository

  public init(repository: HomeViewRepository) {
    self.repository = repository
  }

  public func fetchPopularPosts() -> [PostModel] {
    self.repository.fetchPopularPosts()
  }
}
