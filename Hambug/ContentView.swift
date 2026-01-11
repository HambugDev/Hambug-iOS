//
//  ContentView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import AppDI
import HomePresentation
import HomeDI
import CommunityPresentation
import CommunityDI
import MyPagePresentation
import MyPageDI
import SharedUI

struct ContentView: View {
  @Environment(AppDIContainer.self) var appContainer
  
  private var homeDIContainer: HomeDIContainer {
    HomeDIContainer(appContainer: appContainer)
  }
  
  private var communityDIContainer: CommunityDIContainer {
    CommunityDIContainer(appContainer: appContainer)
  }
  
  private var mypageDIContainer: MyPageDIContainer {
    MyPageDIContainer(appContainer: appContainer)
  }
  
  @State private var selectedTab: Int = 0
  
  var body: some View {
    CustomTabView(selectedTab: $selectedTab) {
      Group {
        NavigationStack {
          HomeView(viewModel: homeDIContainer.homeViewModel)
        }
        .tag(0)
        
        NavigationStack {
          CommunityView(
            viewModel: communityDIContainer.makeCommunityViewModel(),
            writeFactory: communityDIContainer,
            detailFactory: communityDIContainer,
            updateFactory: communityDIContainer,
            reportFactory: communityDIContainer
          )
        }
        .tag(1)
        
        
        NavigationStack {
          MyPageView(
            viewModel: mypageDIContainer.makeMyPageViewModel()
          )
        }
        .tag(2)
      }
      .toolbar(.hidden, for: .tabBar)
    }
  }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
