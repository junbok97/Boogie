//
//  CommunityMemberBanManagementView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/05.
//

import Foundation
import SwiftUI

struct CommunityMemberBanManagementView: View {
    let communityId: Int
    @State var communityMembers: CommunityBannedMembers?
    var body: some View {
        List {
            ForEach(communityMembers?.banned ?? [], id: \.self) { member in
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
                            try await WebService.webService.postBannedMemberRelease(communityId: communityId, memberId: member.memberId)
                            communityMembers?.banned.removeAll { banned in
                                banned.memberId == member.memberId
                            }
                        }
                    } label: {
                        Text("해제")
                            .padding(8)
                            .background(.blue)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .task {
            communityMembers = try? await WebService.webService.getBannedMembers(communityId: communityId)
        }
    }
}


struct CommunityMemberBanManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityMemberBanManagementView(communityId: 5)
    }
}
