//
//  CommunityInfo.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/06.
//

import Foundation
import SwiftUI

struct CommunityInfo: View {
    @Binding var communityDetail: CommunityDetail?
    
    var body: some View {
        VStack {
            HStack {
                Text("\(communityDetail?.community.name ?? "")")
                    .font(.largeTitle)
                Spacer()
                Text("\(communityDetail?.community.isPrivated ?? true ? "공개" : "비공개")")
                Text("|")
                Text("\(CommunityCategory(rawValue: communityDetail?.community.category ?? "")?.type() ?? "")")
            }
            
            Text("\(communityDetail?.community.introduce ?? "")")
                .padding()
            
            HStack {
                ForEach(communityDetail?.community.hashtags ?? [], id: \.self) { hashtag in
                    Text("#\(hashtag)")
                }
            }
            .padding()
            
            HStack {
                Text("\(communityDetail?.community.createdAt ?? "")")
                Spacer()
                NavigationLink {
                    CommunityMembersView(communityId: 1)
                } label: {
                    Image(systemName: "person")
                    Text("\(communityDetail?.community.memberCount ?? "")")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }
}
