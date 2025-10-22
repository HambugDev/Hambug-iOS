//
//  HomeView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    
    private let viewModel: HomeViewModel
    
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
                .safeAreaPadding(.bottom, 100)
            }
            .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
}



struct PopularPostsView: View {
    
    var postItems: [PostModel] // @State
    
    init(postItems: [PostModel]) {
        self.postItems = postItems
    }
    
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("인기글")
                    .foregroundColor(.textG800)
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


#Preview {
    HomeView(viewModel: DIContainer.shared.homeViewModel)
}
