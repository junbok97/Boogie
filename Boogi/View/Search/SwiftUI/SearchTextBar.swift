//
//  SearchBar.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/19.
//

import Foundation
import SwiftUI

struct SearchTextBar: View {
    @Binding var keyword: String
    @Binding var hasCommunitySearchResult: Bool
    @Binding var hasPostSearchResult: Bool
    @Binding var communitySearch: Bool
    
    @Binding var communitySearchResult: CommunitySearchResult?
    @Binding var postSearchResult: PostSearchResult?
    
    @Binding var communities: [CommunitySearchResult.Community]
    @Binding var posts: [PostSearchResult.Post]
    
    @State var isEditing: Bool = false
    
    var body: some View {
        HStack {
            ZStack {
                TextField("Search ...", text: $keyword, onCommit: {
                    self.isEditing = false
                    communitySearchResult = nil
                    postSearchResult = nil
                    communities.removeAll()
                    posts.removeAll()
                    if communitySearch {
                        hasCommunitySearchResult = true
                        hasPostSearchResult = false
                    } else {
                        hasCommunitySearchResult = false
                        hasPostSearchResult = true
                    }
                })
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.gray.opacity(0.2))
                    )
                    .padding()
                    .onTapGesture { self.isEditing = true }
                
                HStack {
                    Spacer()
                    
                    Button {
                        communitySearchResult = nil
                        postSearchResult = nil
                        communities.removeAll()
                        posts.removeAll()
                        if communitySearch {
                            hasCommunitySearchResult = true
                            hasPostSearchResult = false
                        } else {
                            hasCommunitySearchResult = false
                            hasPostSearchResult = true
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.trailing, 30)
                }
            }
            .animation(.default, value: isEditing)
            
            if isEditing {
                Button {
                    self.isEditing = false
                    self.keyword = ""
                } label: {
                    Text("Cancel")
                }
                .padding(.trailing)
            }
        }
    }
}
