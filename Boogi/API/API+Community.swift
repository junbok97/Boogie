//
//  Community.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/29.
//

import Foundation
import Alamofire
import Kingfisher

extension WebService {
    
    func postJoinCommunity(communityId: Int, completionHandler: @escaping(RequestJoinCommunity) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.postJoinCommunity(communityId: communityId, completionHandler: completionHandler)
        }
        AF.request("\(self.base)/communities/\(communityId)/requests", method: .post, headers: tokenheader).responseDecodable(of: RequestJoinCommunity.self) { response in
            guard let requestJoinCommunity = response.value else {return}
            completionHandler(requestJoinCommunity)
        }
        

    }
    
    func getCommunityPostList(communityId: Int, page: Int, size: Int, completionHandler: @escaping (CommuityPostList) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getCommunityPostList(communityId: communityId, page: page, size: size, completionHandler: completionHandler)
        }
        let param = ["page" : page, "size" : size]
        AF.request("\(self.base)/communities/\(communityId)/posts", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: CommuityPostList.self) { response in
                guard let postList = response.value else {return}
                completionHandler(postList)
            }
    }
    
    func getCommunityMembers(communityId: Int, page: Int, size: Int,completionHandler: @escaping (Members) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getCommunityMembers(communityId: communityId, page: page, size: size, completionHandler: completionHandler)
        }
        
        let param = ["page" : page, "size" : size]
        AF.request("\(self.base)/communities/\(communityId)/members", method: .get, parameters: param, headers: tokenheader)
            .responseDecodable(of: Members.self) { response in
                guard let members = response.value else {return}
                completionHandler(members)
            }
    }
    
    func getCommunityDetail2(communityId: Int, completionHandler: @escaping (CommunityDetail2) -> ()) {
        getToken2(){ [weak self] in
            guard let self = self else {return}
            self.getCommunityDetail2(communityId: communityId, completionHandler: completionHandler)
        }
 
        AF.request("\(self.base)/communities/\(communityId)", method: .get, headers: tokenheader)
            .responseDecodable(of: CommunityDetail2.self) { response in
                guard let communityDetail = response.value else {return}
                completionHandler(communityDetail)
            }
    }
    


    func createCommunity(communityInfo: CreateCommunity) async throws -> Void {
        guard let url = URL(string: "\(base)/communities/") else { throw URLError(.badURL) }
        
        let body = try JSONEncoder().encode(communityInfo)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func getCommunityDetail(communityId: Int) async throws -> CommunityDetail? {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var communityDetail = try JSONDecoder().decode(CommunityDetail.self, from: data)
        
        communityDetail.community.createdAt = communityDetail.community.createdAt.components(separatedBy: "T")[0]
        communityDetail.notices?.enumerated().forEach({ (index, item) in
            communityDetail.notices?[index].createdAt = item.createdAt.components(separatedBy: "T")[0]
        })
        communityDetail.posts?.enumerated().forEach({ (index, item) in
            communityDetail.posts?[index].createdAt = item.createdAt.components(separatedBy: "T")[0]
        })
        
        
        return communityDetail
    }
    
    func getCommunityMembers(communityId: Int, page: Int = 0) async throws -> CommunityMembers {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard var url = URLComponents(string: "\(base)/communities/\(communityId)/members") else {
            throw URLError(.badURL)
        }

        url.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(15)")
        ]
        
        guard let url = url.url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var communityMembers = try JSONDecoder().decode(CommunityMembers.self, from: data)
        
        communityMembers.members.enumerated().forEach({ (index, item) in
            communityMembers.members[index].createdAt = getDateTime(datetime: item.createdAt)
        })
        
        return communityMembers
    }
    
    func getJoinRequests(communityId: Int) async throws -> JoinRequests? {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/requests") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let joinRequests = try JSONDecoder().decode(JoinRequests?.self, from: data)
        
        return joinRequests
    }
    
    func postJoinRequests(communityId: Int) async throws -> Void {
        guard let url = URL(string: "\(base)/communities/\(communityId)/requests") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func getCommunitySettings(communityId: Int) async throws -> CommunitySettings? {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        guard let url = URL(string: "\(base)/communities/\(communityId)/settings") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let communitySettings = try JSONDecoder().decode(CommunitySettings.self, from: data)
        
        return communitySettings
    }
    
    func postCommunityIsSecretSettings(communityId: Int, isSecret: Bool?) async throws -> Void {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/settings") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["isSecret": isSecret])
        
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func postCommunityIsAutoSettings(communityId: Int, isAuto: Bool?) async throws -> Void {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/settings") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["isAutoApproval": isAuto])
        
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func postCommunityMemberDelegate(communityId: Int, memberId: Int, memberType: String) async throws -> Void {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/members/delegate") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "memberId": memberId,
                "type": memberType
            ]
        )
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func getBannedMembers(communityId: Int) async throws -> CommunityBannedMembers? {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/members/banned") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let bannedMembers = try JSONDecoder().decode(CommunityBannedMembers?.self, from: data)
        
        return bannedMembers
    }
    
    func postBannedMemberRelease(communityId: Int, memberId: Int) async throws -> Void {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/members/release") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["memberId": memberId]
        )
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func postBanMember(communityId: Int, memberId: Int) async throws -> Void {
        UserInfo.userInfo.XAuthToken = try await getToken(email: UserInfo.userInfo.email)
        
        guard let url = URL(string: "\(base)/communities/\(communityId)/members/ban") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["memberId": memberId]
        )
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func postCommunityJoinRequestConfirm(communityId: Int, requestIds: [Int]) async throws -> Void {
        guard let url = URL(string: "\(base)/communities/\(communityId)/requests/confirm") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["requestIds": requestIds]
        )
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func postCommunityJoinRequestReject(communityId: Int, requestIds: [Int]) async throws -> Void {
        guard let url = URL(string: "\(base)/communities/\(communityId)/requests/reject") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["requestIds": requestIds])
        
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    func getCommunityMetadata(communityId: Int) async throws -> CommunityMetadata {
        guard let url = URL(string: "\(base)/communities/\(communityId)/metadata") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let metadata = try JSONDecoder().decode(CommunityMetadata.self, from: data)
        
        return metadata
    }
    
    func patchCommunityMetadata(communityId: Int, communityData: CommunityMetadata) async throws -> Void {
        guard let url = URL(string: "\(base)/communities/\(communityId)") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "description": communityData.metadata.introduce,
                "hashtags": communityData.metadata.hashtags ?? []
            ]
        )
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    
}
