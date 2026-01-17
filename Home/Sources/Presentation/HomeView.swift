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
import CommunityPresentation
import AlarmPresentation

public protocol Homedependency: HomeFactory {
  var component: CommunityDetailDependency { get }
  var alarmListComponent: AlarmListDependecy { get }
}
public protocol HomeFactory {
  func makeHomeViewModel() -> HomeViewModel
}

public struct HomeView: View {

  @State private var viewModel: HomeViewModel
  private let dependency: Homedependency
  
  public init(
    dependency: Homedependency,
  ) {
    self.dependency = dependency
    self._viewModel = State(initialValue: dependency.makeHomeViewModel())
  }
  
  public var body: some View {
    ZStack {
      Color.bgG100
        .ignoresSafeArea(.container, edges: .top)
      
      VStack {
        HeaderBar(type: .home) {
          AlarmListView(
            dependency: dependency.alarmListComponent
          )
        }
        .safeAreaPadding(18)
        
        ScrollView {
          SuggestView(burgers: viewModel.recommendedBurgers)
            .padding(.leading, 18)
            .padding(.top, 10)

          Spacer()
            .frame(height: 30)

          PopularPostsView(
            postItems: viewModel.trendingPosts,
            dependency: dependency
          )
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
  private let dependency: Homedependency
  
  init(postItems: [TrendingPost], dependency: Homedependency) {
    self.postItems = postItems
    self.dependency = dependency
  }

  var body: some View {
    VStack(spacing: 12) {
      CategoryHeaderText("인기글")

      VStack(spacing: 0) {
        ForEach(postItems) { post in
          NavigationLink(
            destination: CommunityDetailView(
              dependency: dependency.component,
              boardId: post.id
            )
          ) {
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
