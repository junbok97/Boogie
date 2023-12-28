//
//  MemberManagementView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/15.
//

import Foundation
import SwiftUI

struct CommunityMemberManagementView: View {
    let communityId: Int
    @State var communityMembers: CommunityMembers?
    var body: some View {
        List {
            ForEach(communityMembers?.members ?? [], id: \.self) { member in
                HStack {
                    Image(systemName: "photo")
                        .clipShape(Circle())
                    
                    VStack {
                        Text(member.user.name)
                        Text(member.user.tagNum)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await WebService.webService.postBanMember(communityId: communityId, memberId: member.id)
                            communityMembers?.members.removeAll {
                                $0.id == member.id
                            }
                            
                        }
                    } label: {
                        Text("차단")
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
            }
        }
        .navigationTitle("멤버관리")
        .task {
            self.communityMembers = try? await WebService.webService.getCommunityMembers(communityId: communityId)
        }
    }
}
