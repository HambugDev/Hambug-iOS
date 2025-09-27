//
//  HomeViewModel.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    let useCase: HomeViewUseCase
    @Published var postModels: [PostModel] = []
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
        fetchPopularPosts()
    }
    
    
    func fetchPopularPosts() {
        self.postModels = self.useCase.fetchPopularPosts()
    }
}
