//
//  ContentView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import AppCoreDI
import SharedUI
import HomePresentation
import CommunityPresentation
import MyPagePresentation

struct ContentView: View {
  @Environment(AppDIContainer.self) var appContainer
  
  @State private var selectedTab: Int = 0
  
  var body: some View {
    CustomTabView(selectedTab: $selectedTab) {
      Group {
        NavigationStack {
          HomeView(dependency: appContainer.homeDIContainer)
        }
        .tag(0)
        
        NavigationStack {
          CommunityView(dependency: appContainer.communityDIContainer)
        }
        .tag(1)
        
        
        NavigationStack {
          MyPageView(
            viewModel: appContainer.mypageDIContainer.makeMyPageViewModel(),
            activitesFactory: appContainer.mypageDIContainer,
            dependency: appContainer.communityDIContainer
          )
        }
        .tag(2)
      }
      .toolbar(.hidden, for: .tabBar)
    }
    .ignoresSafeArea(.keyboard)
  }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
