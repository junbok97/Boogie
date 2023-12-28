//
//  API+Search.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/23.
//

import Foundation

extension WebService {
    func getCommunitiesSearch(searchParams: SearchParameter, nextPage: Int = 0) async throws -> CommunitySearchResult {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard var url = URLComponents(string: "\(base)/communities/search") else { throw URLError(.badURL) }
        
        url.queryItems = [
            URLQueryItem(name: "category", value: searchParams.category == .all ? nil : searchParams.category.rawValue),
            URLQueryItem(name: "order", value: searchParams.order.rawValue),
            URLQueryItem(name: "keyword", value: searchParams.keyword),
            URLQueryItem(name: "size", value: "5"),
            URLQueryItem(name: "page", value: nextPage.description),
        ]
        if searchParams.isPrivate != .all {
            url.queryItems?.append(
                URLQueryItem(name: "isPrivate", value: searchParams.isPrivate == .private ? "true" : "false")
            )
        }
        
        guard let url = url.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        var res = try JSONDecoder().decode(CommunitySearchResult.self, from: data)
        
        res.communities.enumerated().forEach({ (index, item) in
            res.communities[index].createdAt = getDateTime(datetime: item.createdAt).components(separatedBy: " ")[0]
        })
        
        return res
    }
    
    func getPostsSearch(searchParams: SearchParameter, nextPage: Int = 0) async throws -> PostSearchResult {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard var url = URLComponents(string: "\(base)/posts/search") else { throw URLError(.badURL) }

        url.queryItems = [
            URLQueryItem(name: "order", value: searchParams.order.rawValue),
            URLQueryItem(name: "keyword", value: searchParams.keyword),
            URLQueryItem(name: "size", value: "5"),
            URLQueryItem(name: "page", value: nextPage.description),
        ]
        
        guard let url = url.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var res = try JSONDecoder().decode(PostSearchResult.self, from: data)
        
        res.posts.enumerated().forEach({ (index, item) in
            res.posts[index].createdAt = getDateTime(datetime: item.createdAt)
        })
        
        print(res)
        
        return res
    }
}
