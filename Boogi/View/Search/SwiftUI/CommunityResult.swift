//
//  CommunityResult.swift
//  Boogi
//
//  Created by 김덕환 on 2022/06/02.
//

import Foundation
import SwiftUI

struct CommunityResult: View {
    let community: CommunitySearchResult.Community
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(community.name)
                    .font(.largeTitle)
                
                Spacer()
                
                Text("\(community.private ? "비공개" : "공개")")
                
                Text(" | ")
                
                Text("\(CommunityCategory(rawValue: community.category)?.type() ?? "")")
            }
            
            Text(community.description)
                .padding([.top, .bottom])
            
            HStack {
                ForEach(community.hashtags ?? [], id: \.self) { tag in
                    Text("#\(tag)")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            HStack {
                Text(community.createdAt)
                Spacer()
                Image(systemName: "person.fill")
                Text(community.memberCount.description)
            }
        }
    }
}
