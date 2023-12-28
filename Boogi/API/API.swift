//
//  API.swift
//  Boogi
//
//  Created by 김덕환 on 2022/03/19.
//

import Foundation
import SwiftUI
import Alamofire

struct APIError: Error, Codable {
    let code: String
    let message: String
    let statusCode: Int
    let timestamp: String
}
    

class WebService {
    private init() { }
    
    static let webService = WebService()
    
    let base = "http://3.36.237.197:8080/api"
    let imgBase = "http://3.36.237.197:8081"
    let auth = "X-Auth-Token"
    
    var tokenheader: HTTPHeaders {
        get {
            return HTTPHeaders(["X-Auth-Token" :UserInfo.userInfo.XAuthToken ?? ""])
        }
    }

    enum http: Int {
        case get = 0, post, patch, delete
        func toString() -> String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }
    
    
    func getToken(email: String?) async throws -> String? {
        if UserInfo.userInfo.XAuthToken != nil { return UserInfo.userInfo.XAuthToken }
        
        guard let url = URL(string: "\(base)/users/token/\(email ?? "")") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { return nil }
        
        let token = response.value(forHTTPHeaderField: auth)

        return token
    }
    
    func getToken2(completionHanlder: @escaping () -> ()) {
        if UserInfo.userInfo.XAuthToken != nil {return}
        
        AF.request("\(self.base)/users/token/\(UserInfo.userInfo.email ?? "")", method: .post)
            .responseData { (response) in
                let token = response.response?.value(forHTTPHeaderField: self.auth)
                UserInfo.userInfo.XAuthToken = token
                completionHanlder()
            }
    }    
    
    func getDateTime(datetime: String) -> String {
        let tokens = datetime.components(separatedBy: ["T", "-", ":", "."])
        
        return "\(tokens[0][tokens[0].index(tokens[0].startIndex, offsetBy: 2)...]).\(tokens[1]).\(tokens[2]) \(tokens[3]):\(tokens[4])"
    }
}
