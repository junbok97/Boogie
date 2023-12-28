//
//  CommunityPosts.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/06.
//

import Foundation
import SwiftUI

struct CommunityPosts: View {
    @Binding var communityDetail: CommunityDetail?
    
    var body: some View {
        VStack {
            HStack {
                Text("게시글")
                    .font(.largeTitle)
                Spacer()
                NavigationLink {
                } label: {
                    Text("더보기")
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            ForEach(communityDetail?.posts ?? [], id: \.self) { post in
                NavigationLink {
                    Text(post.content)
                } label: {
                    HStack {
                        Text(post.content)
                        Spacer()
                        Text(post.createdAt)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .foregroundColor(.gray)
            }
            .padding([.leading, .trailing])
        }
    }
}
