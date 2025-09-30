//
//  CommunityView.swift
//  Hambug
//
//  Created by 강동영 on 9/29/25.
//

import SwiftUI

struct CommunityView: View {
    @State private var selectedCategory: String = "전체"
    
    @State private var communityPosts: [CommunityPost] = .sampleData
    private let categories = ["전체", "자유잡담", "햄버거리뷰", "맛집추천"]
    
    var body: some View {
        ZStack {
            VStack {
                Color(UIColor(hexCode: "#EC6D55"))
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                Color(UIColor(hexCode: "#F8F8F7"))
            }
            .ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                // 주황색 상단 영역 (헤더 + 카테고리 + 상단 여백)
                // 헤더
                HStack {
                    Text("커뮤니티")
                        .pretendard(.title(.t1))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Notification tapped")
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                VStack(spacing: 0) {
                    // 카테고리 필터
                    CategoryFilterListView(
                        categories: categories,
                        selectedCategory: $selectedCategory
                    )
                    .padding(.bottom, 10)
                    
                    // 스크롤 뷰 (흰색 배경)
                    CommunityListView(communityPosts: $communityPosts)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: CategoryFilter
fileprivate struct CategoryFilterListView: View {
    private let categories: [String]
    @Binding var selectedCategory: String
    
    init(
        categories: [String],
        selectedCategory: Binding<String>
    ) {
        self.categories = categories
        self._selectedCategory = selectedCategory
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    CommunityFilterChip(
                        category: category,
                        selectedCategory: $selectedCategory
                    )
                }
            }
            Spacer()
        }
    }
}

fileprivate struct CommunityFilterChip: View {
    private let category: String
    @Binding var selectedCategory: String
    
    init(category: String, selectedCategory: Binding<String>) {
        self.category = category
        self._selectedCategory = selectedCategory
    }
    
    var body: some View {
        Text(category)
            .pretendard(.body(.sEmphasis))
            .foregroundColor(selectedCategory == category ? Color(UIColor(hexCode: "#EC7A60")) : .black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(selectedCategory == category ? Color.white.opacity(0.2) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(selectedCategory == category ? Color.clear : Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

// MARK: CommunityList
fileprivate struct CommunityListView: View {
    @Binding var communityPosts: [CommunityPost]
    
    init(
        communityPosts: Binding<[CommunityPost]>
    ) {
        self._communityPosts = communityPosts
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(communityPosts) { post in
                    CommunityPostCard(post: post)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .padding(-2) // Spread 값만큼 음수 패딩
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 4.5,
                    x: 0,
                    y: 0
                )
        )
        .background(Color.white)
    }
}

fileprivate struct CommunityPostCard: View {
    private let post: CommunityPost
    
    init(post: CommunityPost) {
        self.post = post
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(post.title)
                            .pretendard(.title(.t2))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.trailing, 8)
                        
                        Text("2분 전")
                        Spacer()
                    }
                    
                    
                    HStack(spacing: 4) {
                        Text("패티포터")
                            .pretendard(.caption(.emphasis))
                            .foregroundColor(Color(UIColor(hexCode: "#EC7A60")))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(UIColor(hexCode: "#EC7A60")))
                                .font(.system(size: 12))
                            
                            Text("\(post.likes)")
                                .pretendard(.caption(.base))
                                .foregroundColor(Color(UIColor(hexCode: "#666666")))
                            
                            Image(systemName: "message.fill")
                                .foregroundColor(Color(UIColor(hexCode: "#666666")))
                                .font(.system(size: 12))
                            
                            Text("\(post.comments)")
                                .pretendard(.caption(.base))
                                .foregroundColor(Color(UIColor(hexCode: "#666666")))
                        }
                    }
                }
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor(hexCode: "#F5F5F5")))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(Color(UIColor(hexCode: "#CCCCCC")))
                            .font(.system(size: 24))
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            
            Divider()
                .background(Color(UIColor(hexCode: "#F0F0F0")))
        }
    }
}

struct CommunityPost: Identifiable {
    let id = UUID()
    let title: String
    let timeAgo: String
    let likes: Int
    let comments: Int
}

extension [CommunityPost] {
    static let sampleData: [CommunityPost] = [
        CommunityPost(title: "다들?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "짧은 타이틀", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "긴 타이틀입니다 123?3123123", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "버거추천", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "짧은 타이틀", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "타이틀", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "버거추천", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6),
        CommunityPost(title: "다들 햄치됐인가요?", timeAgo: "2분 전", likes: 11, comments: 6)
    ]
        
}
#Preview {
//    CommunityView()
    ContentView()
}
