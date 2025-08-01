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
            Color(UIColor(hexCode: "#F4F5F7"))
            
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
            
            Button(action: {
                print(#file, #line, #function, "마이 탭")
            }) {
                Image(systemName: "person.fill")
            }
            .foregroundColor(.black)
            
            
            
        }
        .padding()
        
    }
}


struct SuggestView: View {
    var body: some View {
        VStack {
            Text("추천 햄버거 페이지")
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

struct PopularPostsView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("인기글")
                Spacer()
                Image(systemName: "chevron.right")
            }
            
            Rectangle()
                .frame(height: 1)
                .cornerRadius(10)
            
            PostView()
            PostView()
            
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        
    }
}

struct PostView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("글 제목")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    HStack {
                        Text("03.02")
                        Text("12:22")
                        
                        Image(systemName: "heart.fill")
                        Text("11")
                        
                        Image(systemName: "bubble.fill")
                        Text("6")
                        
                    }
                }
                
                Spacer()
                
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
            
            Rectangle()
                .frame(height: 1)
                .cornerRadius(10)
            
        }
        
    }
}



#Preview {
    HomeView()
}
