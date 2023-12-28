//
//  CommunityManagerDelegateView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/05.
//

import Foundation
import SwiftUI

struct CommunityManagerDelegateView: View {
    @State var communityMembers = CommunityMembers(
        pageInfo: CommunityMembers.PageInfo(nextPage: 0, totalCount: 0, hasNext: false),
        members: []
    )
    var communityId: Int
    
    struct ManagerButton: View {
        let communityId: Int
        let member: CommunityMembers.Member
        var body: some View {
            Button {
                Task {
                    try await WebService.webService.postCommunityMemberDelegate(
                        communityId: communityId, memberId: member.id, memberType: "MANAGER"
                    )
                }
            } label: {
                Text("매니저")
                    .padding(8)
                    .background(.blue)
                    .cornerRadius(15)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    struct SubManagerButton: View {
        let communityId: Int
        let member: CommunityMembers.Member
        
        var body: some View {
            Button {
                Task {
                    try await WebService.webService.postCommunityMemberDelegate(
                        communityId: communityId, memberId: member.id, memberType: "SUB_MANAGER"
                    )
                }
            } label: {
                Text("부매니저")
                    .padding(8)
                    .background(.blue)
                    .cornerRadius(15)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    var body: some View {
        List {
            ForEach(communityMembers.members, id: \.self) { member in
                HStack {
                    Image(systemName: "person.fill")
                    VStack {
                        Text(member.user.name)
                        Text(member.user.tagNum)
                    }
                    
                    Spacer()
                    
                    HStack {
                        if member.memberType != "MANAGER" {
                            ManagerButton(communityId: communityId, member: member)
                        }
                        
                        if member.memberType != "SUB_MANAGER" {
                            SubManagerButton(communityId: communityId, member: member)
                        }
                    }
                }
            }
        }
        .task {
            do {
                communityMembers = try await WebService.webService.getCommunityMembers(communityId: communityId)
            } catch {
            }
        }
    }
}
