//
//  CommunityMembersView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/12.
//

import Foundation
import SwiftUI

struct CommunityMembersView: View {
    @State var communityMembers: CommunityMembers?
    var communityId: Int
    
    var body: some View {
        List {
            ForEach(communityMembers?.members ?? [], id: \.self) { member in
                HStack {
                    Image(systemName: "photo")
                        .clipShape(Circle())
                    VStack {
                        Text("\(member.user.name)")
                        Text("\(member.user.tagNum)")
                    }
                    Spacer()
                    Text("\(member.user.department)")
                    Spacer()
                    VStack {
                        Text("\(Role(rawValue: member.memberType)?.type() ?? "")")
                        Text("\(member.createdAt)")
                    }
                }
            }
        }
        .task {
            communityMembers = try? await WebService.webService.getCommunityMembers(communityId: communityId)
        }
    }
}
