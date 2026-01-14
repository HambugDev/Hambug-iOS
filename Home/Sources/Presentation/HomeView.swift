//
//  HomeView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import HomeDomain
import DesignSystem
import SharedUI
import CommunityDI
import CommunityPresentation

public struct HomeView: View {

  @State private var viewModel: HomeViewModel

  public init(viewModel: HomeViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    ZStack {
      Color.bgG100
        .ignoresSafeArea(.container, edges: .top)
      
      VStack {
        HeaderBar(type: .home)
          .safeAreaPadding(18)
        
        ScrollView {
          SuggestView(burgers: viewModel.recommendedBurgers)
            .padding(.leading, 18)
            .padding(.top, 10)

          Spacer()
            .frame(height: 30)

          PopularPostsView(postItems: viewModel.trendingPosts)
            .padding(.horizontal, 18)

        }
        .safeAreaPadding(.bottom, 60)
      }
    }
    
    .tabBarHidden(false)
  }
}



struct PopularPostsView: View {
  private let postItems: [TrendingPost]
  private let communityDIContainer: CommunityDIContainer
  
  init(postItems: [TrendingPost]) {
    self.postItems = postItems
    self.communityDIContainer = .init(appContainer: .shared)
  }

  var body: some View {
    VStack(spacing: 12) {
      CategoryHeaderText("인기글")

      VStack(spacing: 0) {
        ForEach(postItems) { post in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: communityDIContainer.makeDetailViewModel(),
              boardId: post.id,
              updateFactory: communityDIContainer,
              reportFactory: communityDIContainer
            )) {
              PostView(post: post)
          }
        }
      }
      .background(.white)
      .cornerRadius(16)
      .shadow(radius: 6)
    }
  }
}

struct CategoryHeaderText: View {
  private let title: String
  
  init(_ title: String) {
    self.title = title
  }
  var body: some View {
    HStack {
      Text(title)
        .pretendard(.title(.t2))
      Spacer()
    }
  }
}
