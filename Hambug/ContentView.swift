//
//  ContentView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            CommunityView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("커뮤니티")
                }
        }
    }
}


//MARK: - Preview
#Preview {
    ContentView()
}
