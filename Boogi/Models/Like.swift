//
//  Like.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/27.
//

import Foundation

struct LikeList: Codable {
    var members: [User]?
    var pageInfo: PageInfo
    
    struct User: Codable {
        let id: Int
        let name: String
        let tagNum: String
        let profileImageUrl: String?
    }
}

//struct Like: Codable {
//    var id: Int
//}

