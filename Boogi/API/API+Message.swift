//
//  API+Message.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/21.
//

import Foundation

extension WebService {
    func getMessageList() async throws -> MessageList {
        guard let url = URL(string: "\(base)/messages/") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var list = try JSONDecoder().decode(MessageList.self, from: data)
        
        list.messageRooms.enumerated().forEach({ (index, item) in
            list.messageRooms[index].recentMessage.receivedAt = getDateTime(datetime: item.recentMessage.receivedAt).replacingOccurrences(of: " ", with: "\n")
        })
        
        return list
    }
    
    func getMessageDetail(opponentId: Int) async throws -> MessageDetail {
        guard let url = URL(string: "\(base)/messages/\(opponentId)") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var list = try JSONDecoder().decode(MessageDetail.self, from: data)
        
        list.messages.enumerated().forEach({ (index, item) in
            list.messages[index].receivedAt = getDateTime(datetime: item.receivedAt)
        })
        
        return list
    }
    
    func postMessage(opponentId: Int, msg: String) async throws -> Int {
        guard let url = URL(string: "\(base)/messages/") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "receiverId": opponentId,
            "content": msg,
        ])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let id = try JSONDecoder().decode(PostSuccess.self, from: data)
        
        return id.id
    }
}
