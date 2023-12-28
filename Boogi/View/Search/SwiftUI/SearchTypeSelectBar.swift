//
//  SearchTypeSelectBar.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/19.
//

import Foundation
import SwiftUI

struct SearchTypeSelectBar: View {
    @Binding var communitySearch: Bool
    @Binding var isOnlyPrivate: SearchParameter.isPrivate
    @Binding var ordering: Ordering
    
    
    var body: some View {
        HStack {
            Button {
                communitySearch = true
                ordering = .newer
            } label: {
                Text("커뮤니티")
            }
            .foregroundColor(communitySearch ? .blue : .black)
            
            Button {
                communitySearch = false
                ordering = .newer
            } label: {
                Text("게시글")
            }
            .foregroundColor(communitySearch ? .black : .blue)
            
            Spacer()
            
            if communitySearch {
                Picker(isOnlyPrivate.type(), selection: $isOnlyPrivate) {
                    Text("전체")
                        .tag(SearchParameter.isPrivate.all)
                    Text("공개")
                        .tag(SearchParameter.isPrivate.public)
                    Text("비공개")
                        .tag(SearchParameter.isPrivate.private)
                }
            }
            
            Picker("", selection: $ordering) {
                Text(Ordering.newer.type())
                    .tag(Ordering.newer)
                Text(Ordering.older.type())
                    .tag(Ordering.older)
                if communitySearch {
                    Text(Ordering.manyPeople.type())
                        .tag(Ordering.manyPeople)
                    Text(Ordering.lessPeople.type())
                        .tag(Ordering.lessPeople)
                } else {
                    Text(Ordering.likeUpper.type())
                        .tag(Ordering.likeUpper)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}
