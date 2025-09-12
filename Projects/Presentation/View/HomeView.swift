//
//  HomeView.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        
        ZStack {
            Color(UIColor(hexCode: "#F8F8F7"))
            
            VStack {
                HeaderBar()
                
                ScrollView {
                    SuggestView()
                        .background(.white)
                    
                    PopularPostsView()
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
            Image(systemName: "signature")
            Spacer()
            
            Button(action: {
                print(#file, #line, #function, "알림 탭")
            }) {
                Image(systemName: "bell.fill")
            }
            .foregroundColor(.black)
            
            
            
        }
        .padding()
        
    }
}

struct PopularPostsView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("인기글")
                Spacer()
            }
            
            
            PostView(
                postItem: PostModel(
                    postCodableItem: PostCodableItem(
                        id: 1, title: "글 제목입니다.", content: "글 내용입니다.", createdAt: Date(), updatedAt: Date()
                    )
                )
            )
            
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        
    }
}



#Preview {
    HomeView()
}
