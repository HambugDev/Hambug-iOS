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
      HomeView(viewModel: homeDIContainer.homeViewModel)
        .tag(0)
      
      CommunityView(viewModel: communityDIContainer.makeCommunityViewModel())
        .tag(1)
      
      MyPageView(viewModel: mypageDIContainer.makeMyPageViewModel())
        .tag(2)
    }
  }
}


//MARK: - Preview
#Preview {
    ContentView()
        .environment(AppDIContainer.shared)
}
