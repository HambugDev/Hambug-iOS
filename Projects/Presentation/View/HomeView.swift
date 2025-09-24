//
//  HomeView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    
    var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        
        ZStack {
            Color(UIColor(hexCode: "#F8F8F7"))
            
            VStack {
                HeaderBar()
                
                ScrollView {
                    SuggestView()
                    
                    PopularPostsView(postItems: viewModel.postModels)
                        .padding()
                }
                
            }
            .padding(.top, 50)
        }
        .ignoresSafeArea()
        
    }
}

// 상단 헤더 - 로고, 알림
struct HeaderBar: View {
    var body: some View {
        HStack(spacing: 10) {
            Image("hambug_icon")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("햄버그")
                .pretendard(.title(.t1))
                .foregroundColor(.primaryHambugRed)
            Spacer()
        }
        .padding()
        
    }
}

struct PopularPostsView: View {
    
    var postItems: [PostModel]
    
    init(postItems: [PostModel]) {
        self.postItems = postItems
    }
    
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("인기글")
                Spacer()
            }
            
            ForEach(postItems) { post in
                PostView(postModel: post)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 6)
        
    }
}

class HomeViewModel: ObservableObject {
    
    var useCase: HomeViewUseCase
    @Published var postModels: [PostModel] = []
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
        fetchPopularPosts()
    }
    
    
    func fetchPopularPosts() {
        self.postModels = self.useCase.fetchPopularPosts()
    }
}

class HomeViewUseCase {
    
    var repository: HomeViewRepository
    
    init(repository: HomeViewRepository) {
        self.repository = repository
    }
    
    func fetchPopularPosts() -> [PostModel] {
        self.repository.fetchPopularPosts()
    }
}

protocol HomeViewRepository {
    func fetchPopularPosts() -> [PostModel]
}

class DummyHomeViewRepositoryImpl: HomeViewRepository {
    
    func fetchPopularPosts() -> [PostModel] {
        return [
            PostCodableItem(id: 1, title: "글 제목입니다.1", content: "글 내용입니다.1", createdAt: Date(), updatedAt: Date()),
            PostCodableItem(id: 2, title: "글 제목입니다.2", content: "글 내용입니다.2", createdAt: Date(), updatedAt: Date()),
            PostCodableItem(id: 3, title: "글 제목입니다.3", content: "글 내용입니다.3", createdAt: Date(), updatedAt: Date()),
            PostCodableItem(id: 4, title: "글 제목입니다.4", content: "글 내용입니다.4", createdAt: Date(), updatedAt: Date()),
            PostCodableItem(id: 5, title: "글 제목입니다.5", content: "글 내용입니다.5", createdAt: Date(), updatedAt: Date())
        ].map {
            PostModel(postCodableItem: $0)
        }
    }
}


class DIContainer {
    static let shared = DIContainer()
    
    init() {}
    
    var homeViewRepository: HomeViewRepository {
        DummyHomeViewRepositoryImpl()
    }
    
    var homeViewUseCase: HomeViewUseCase {
        HomeViewUseCase(repository: homeViewRepository)
    }
    
    var homeViewModel: HomeViewModel {
        HomeViewModel(useCase: homeViewUseCase)
    }
}



#Preview {
    HomeView(viewModel: DIContainer.shared.homeViewModel)
}
