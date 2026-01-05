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

    var post: TrendingPost

    public init(post: TrendingPost) {
        self.post = post
    }

    public var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.title)
                        .pretendard(.title(.t2))
                        .foregroundColor(.textG800)

                    HStack {
                        Text(post.category)
                            .pretendard(.caption(.emphasis))
                            .foregroundColor(.primaryHambugRed)

                        Text("·")
                            .foregroundColor(.bgG200)

                        HStack(spacing: 5) {
                            Text(post.formattedDate)
                                .pretendard(.caption(.emphasis))
                                .foregroundColor(.iconG600)

                            Text(post.formattedTime)
                                .pretendard(.caption(.emphasis))
                                .foregroundColor(.iconG600)
                        }
                    }
                }

                Spacer()

                // 첫 번째 이미지가 있으면 표시
                if let firstImageUrl = post.imageUrls.first,
                   let url = URL(string: firstImageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                    .frame(width: 56, height: 56)
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .frame(width: 56, height: 56)
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                }
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
                post: TrendingPost(
                    id: 1,
                    title: "글 제목입니다.",
                    content: "글 내용입니다.",
                    category: "FREE_TALK",
                    imageUrls: [],
                    authorNickname: "테스트",
                    authorId: 1,
                    createdAt: Date(),
                    updatedAt: Date(),
                    viewCount: 100,
                    likeCount: 10,
                    commentCount: 5,
                    isLiked: false
                )
            )
            .padding()

            FeedPostView()
                .padding()
        }
    }
}
