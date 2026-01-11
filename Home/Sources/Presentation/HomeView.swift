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

public struct HomeView: View {

  @State private var viewModel: HomeViewModel

  public init(viewModel: HomeViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    
    ZStack {
      Color.bgG100
      
      VStack {
        HeaderBar()
        
        ScrollView {
          SuggestView(burgers: viewModel.recommendedBurgers)
            .padding(.leading, 18)

          Spacer()
            .frame(height: 30)

          PopularPostsView(postItems: viewModel.trendingPosts)
            .padding(.horizontal, 18)

        }
        .safeAreaPadding(.bottom, 100)
      }
      .padding(.top, 50)
    }
    .ignoresSafeArea(.container, edges: .top)
    .tabBarHidden(false)
  }
}



struct PopularPostsView: View {
  private let postItems: [TrendingPost]

  init(postItems: [TrendingPost]) {
    self.postItems = postItems
  }

  var body: some View {
    VStack(spacing: 12) {
      CategoryHeaderText("인기글")

      VStack(spacing: 0) {
        ForEach(postItems) { post in
          PostView(post: post)
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
