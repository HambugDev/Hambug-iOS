//
//  HomeViewModel.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import HomeDomain

public final class HomeViewModel: ObservableObject {

    let useCase: HomeViewUseCase
    @Published public var postModels: [PostModel] = []

    public init(useCase: HomeViewUseCase) {
        self.useCase = useCase
        fetchPopularPosts()
    }


    public func fetchPopularPosts() {
        self.postModels = self.useCase.fetchPopularPosts()
    }
}
