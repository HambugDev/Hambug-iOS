//
//  PostView.swift
//  Hambug
//
//  Created by 차상진 on 8/4/25.
//

import SwiftUI
import DesignSystem
import HomeDomain

public struct PostView: View {

    var postModel: PostModel

    public init(postModel: PostModel) {
        self.postModel = postModel
    }

    public var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(postModel.title)
                        .pretendard(.title(.t2))
                        .foregroundColor(.textG800)
                    
                    HStack {
                        Text("게시판")
                            .pretendard(.caption(.emphasis))
                            .foregroundColor(.primaryHambugRed)
                        
                        Text("·")
                            .foregroundColor(.bgG200)
                        
                        HStack(spacing: 5) {
                            Text(postModel.date)
                                .pretendard(.caption(.emphasis))
                                .foregroundColor(.iconG600)
                            
                            Text(postModel.time)
                                .pretendard(.caption(.emphasis))
                                .foregroundColor(.iconG600)
                        }
                    }
                }
                
                Spacer()
                
                Rectangle()
                    .frame(width: 56, height: 56)
                    .cornerRadius(8)
                    .foregroundColor(.gray)
            }
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다. 내용이 들어가는 자리입니다.")
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            PostView(
                postModel: PostModel(
                    postCodableItem: PostCodableItem(
                        id: 1, title: "글 제목입니다.", content: "글 내용입니다.", createdAt: Date(), updatedAt: Date()
                    )
                )
            )
            .padding()
            
            FeedPostView()
                .padding()
        }
    }
}
