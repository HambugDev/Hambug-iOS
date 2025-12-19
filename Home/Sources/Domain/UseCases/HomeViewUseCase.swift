//
//  HomeViewUseCase.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation

public protocol HomeViewUseCase {
  func fetchPopularPosts() -> [PostModel]
}

