//
//  Member.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/22.
//

import Foundation

enum MemberType: String {
    case manager = "MANAGER", subManager = "SUB_MANAGER", normal = "NORMAL"
    case outsider = ""
    
    func type() -> String {
        switch self {
        case .manager:
            return "매니저"
        case .subManager:
            return "부매니저"
        case .normal:
            return "일반 멤버"
        default :
            return ""
        }
    }
}

struct Members: Codable, Hashable {
    var members: [Member]
    var pageInfo: PageInfo
}

struct Member: Codable, Hashable {
    var id: Int
    var memberType: String
    var createdAt: String?
    var user: User?
}
