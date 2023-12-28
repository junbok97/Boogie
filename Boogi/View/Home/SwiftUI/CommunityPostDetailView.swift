//
//  CommunityPostsDetail.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/07.
//

import Foundation
import SwiftUI

struct CommunityPostDetailView: View {
    @State var postDetail: PostDetail? = nil
    let postId: Int
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(postDetail?.user.name ?? "")
                    Text(postDetail?.user.tagNum ?? "")
                }
                Spacer()
                Text(postDetail?.createdAt ?? "")
            }
            .padding()
            
            Text(postDetail?.content ?? "")
                .frame(alignment: .topLeading)
                .padding()
            
            
            Divider()
                .background(.gray)
            
            HStack {
                Image(systemName: postDetail?.likeId ?? 0 > 0 ? "heart.fill" : "heart")
                Text("\(postDetail?.likeCount ?? 0)")
                Image(systemName: "ellipsis.bubble")
                Text("\(postDetail?.commentCount ?? 0)")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding()
            
            Text("")
        }
        .task {
            self.postDetail = try? await WebService.webService.getPostDetail(postId: postId)
        }
    }
}
