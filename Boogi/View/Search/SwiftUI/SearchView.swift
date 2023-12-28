//
//  SearchView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/15.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @State var communitySearch: Bool = true
    
    @State var searchParams = SearchParameter()
    
    @State var hasCommunitySearchResult = false
    @State var hasPostSearchResult = false
    
    @State var communitySearchResult: CommunitySearchResult? = nil
    @State var postSearchResult: PostSearchResult? = nil
    @State var communities: [CommunitySearchResult.Community] = []
    @State var posts: [PostSearchResult.Post] = []
    
    var body: some View {
        VStack {
            SearchTextBar(
                keyword: $searchParams.keyword,
                hasCommunitySearchResult: $hasCommunitySearchResult,
                hasPostSearchResult: $hasPostSearchResult,
                communitySearch: $communitySearch,
                communitySearchResult: $communitySearchResult,
                postSearchResult: $postSearchResult,
                communities: $communities,
                posts: $posts
            )
            
            SearchTypeSelectBar(
                communitySearch: $communitySearch,
                isOnlyPrivate: $searchParams.isPrivate,
                ordering: $searchParams.order
            )
            
            Divider()
                .foregroundColor(.black)
            
            if communitySearch {
                SearchCommunityCategoryBar(category: $searchParams.category)
            }
            
            if hasCommunitySearchResult {
                CommunitySearchResultView(
                    searchParams: $searchParams,
                    res: $communitySearchResult,
                    communities: $communities
                )
            }
            
            if hasPostSearchResult {
                PostSearchResultView(
                    searchParams: $searchParams,
                    res: $postSearchResult,
                    posts: $posts
                )
            }
            
            Spacer()
        }
        .transition(.opacity)
        .animation(.default, value: communitySearch)
        .onChange(of: communitySearch) { _ in
            hasCommunitySearchResult = false
            hasPostSearchResult = false
        }
        .onAppear {
            hasCommunitySearchResult = true
        }
    }
}
