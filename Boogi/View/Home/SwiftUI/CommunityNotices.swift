//
//  CommunityNotices.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/06.
//

import Foundation
import SwiftUI

struct CommunityNotices: View {
    @Binding var communityDetail: CommunityDetail?
    
    var body: some View {
        VStack {
            HStack {
                Text("공지사항")
                    .font(.largeTitle)
                Spacer()
                Button {
                } label: {
                    Text("더보기")
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            ForEach(communityDetail?.notices ?? [], id: \.self) { noti in
                NavigationLink {
                } label: {
                    HStack {
                        Text(noti.title)
                        Spacer()
                        Text(noti.createdAt)
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
