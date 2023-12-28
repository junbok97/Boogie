//
//  CommunitySettingView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/12.
//

import Foundation
import SwiftUI

struct CommunitySettingView: View {
    let communityId: Int
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink {
                CommunityJoinRequestsView(communityId: communityId)
            } label: {
                Text("가입 승인")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            NavigationLink {
                CommunityMemberManagementView(communityId: communityId)
            } label: {
                Text("멤버 관리")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            NavigationLink {
                CommunityMemberBanManagementView(communityId: communityId)
            } label: {
                Text("차단 목록")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            NavigationLink {
                CommunitySettingDetailView(communityId: communityId)
            } label: {
                Text("커뮤니티 설정")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            
            Spacer()
        }
    }
}
