//
//  Main.swift
//  Boogi
//
//  Created by 김덕환 on 2022/03/29.
//

import Foundation
import SwiftUI


struct CommunityDetailView: View {
    @State private var communityDetail: CommunityDetail? = nil
    let communityId: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CommunityInfo(communityDetail: $communityDetail)
                    
                    Divider()
                        .background(.black)
                    
                    CommunityNotices(communityDetail: $communityDetail)
                    
                    Divider()
                        .background(.black)
                    
                    CommunityPosts(communityDetail: $communityDetail)
                }
                .task {
                    self.communityDetail = try? await WebService.webService.getCommunityDetail(communityId: 1)
                }
            }
        }
    }
}

struct CommunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDetailView(communityId: 1)
    }
}
