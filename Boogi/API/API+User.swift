//
//  API+User.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/20.
//

import Foundation
import Alamofire

extension WebService {
    
    func getUserProfile(userId: Int?, completionHandler: @escaping (Profile) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getUserProfile(userId: userId, completionHandler: completionHandler)
        }
        
        var param: [String: Any]?

        if userId == nil {
            param = ["userId" : ""]
        } else {
            param = ["userId" : userId!]
        }

        AF.request("\(self.base)/users", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: Profile.self) { response in
                guard let profile = response.value else {return}
                completionHandler(profile)
            }
    }
    
    
    func getUserPostList(userId: Int?, page: Int, size: Int,completionHandler: @escaping (ProfilePostList) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getUserPostList(userId: userId, page: page, size: size, completionHandler: completionHandler)
        }
        
        
        var param: [String: Int]?

        if userId == nil {
            param = ["page" : page, "size" : size]
        } else {
            param = ["userId" : userId!, "page" : page, "size" : size]
        }
        
        AF.request("\(self.base)/posts/users", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: ProfilePostList.self) { response in
                guard let posts = response.value else {return}
                completionHandler(posts)
            }

    }
    
    func getUserCommentList(userId: Int?, page: Int, size: Int, completionHandler: @escaping (ProfileCommentList) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getUserCommentList(userId: userId, page: page, size: size, completionHandler: completionHandler)
        }
        
        
        var param: [String: Int]?

        if userId == nil {
            param = ["page" : page, "size" : size]
        } else {
            param = ["userId" : userId!, "page" : page, "size" : size]
        }

        AF.request("\(self.base)/comments/users", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: ProfileCommentList.self) { response in
                guard let comments = response.value else {return}
                completionHandler(comments)
            }
    }
    
    func getJoinCommunityList(completionHandler: @escaping (JoinCommunity?) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getJoinCommunityList(completionHandler: completionHandler)
        }

        AF.request("\(self.base)/users/communities/joined", method: .get, headers: tokenheader)
            .responseDecodable(of: JoinCommunity.self) { response in
                guard let joinCommunity = response.value else {return}
                completionHandler(joinCommunity)
            }
    }
    
    
    func getJoinedCommunity() async throws -> JoinedCommunity {
        guard let url = URL(string: "\(base)/users/communities/joined") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let joinedCommunity = try JSONDecoder().decode(JoinedCommunity.self, from: data)
        
        return joinedCommunity
    }
}
