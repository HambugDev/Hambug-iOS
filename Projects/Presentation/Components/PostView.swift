//
//  PostView.swift
//  Hambug
//
//  Created by 차상진 on 8/4/25.
//

import SwiftUI

struct ListPostView: View {
    var body: some View {
        VStack(alignment: .center) {
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
        .padding()
        .background(.white)
        
    }
}

struct FeedPostView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Rectangle()
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 14) {
                Text("제목이 들어가는 자리입니다.")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading) // 👈 이 부분을 추가
                
                Text("내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다.")
                    .frame(maxWidth: .infinity, alignment: .leading) // 👈 이 부분을 추가
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding()
        .background(.white)
    }
}


#Preview {
    
    ZStack {
        Color.gray
        
        VStack {
            ListPostView()
                .padding()
            
            FeedPostView()
                .padding()
            
        }
        
    }
    
}
