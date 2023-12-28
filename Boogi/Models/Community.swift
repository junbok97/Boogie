//
//  Community.swift
//  Boogi
//
//  Created by 김덕환 on 2022/03/29.
//

import Foundation

// 준복

struct RequestJoinCommunity: Codable {
    let requestId: Int?
    let servermessage: ServerMessage?
}

struct CommuityPostList: Codable {
    var posts: [Post]
    var memberType: String?
    var communityName: String
    var pageInfo: PageInfo
}

struct Community: Codable,Hashable {
    var isPrivated: Bool
    var category: String?
    var name: String
    var introduce: String
    var hashtags: [String]?
    var memberCount: String
    var createdAt: String
}

struct CommunityDetail2: Codable, Hashable {
    var sessionMemberType: String?
    var community: Community
    var notices: [Notice]?
    var posts: [Post]?
}


// 덕환

struct JoinedCommunity: Codable {
    struct Community: Codable, Hashable {
        var name: String
        var id: Int
        var post: Post?
    }
    var communities: [Community]
}

enum CommunityCategory: String, Codable, CaseIterable, Identifiable {
    case all = "ALL", academic = "ACADEMIC", club = "CLUB", hobby = "HOBBY", other = "OTHER"
    var id: Self { self }
    
    func type() -> String {
        switch self {
        case .all:
            return "전체"
        case .academic:
            return "학사"
        case .club:
            return "동아리"
        case .hobby:
            return "취미"
        case .other:
            return "기타"
        }
    }
}


struct CreateCommunity: Codable {
    var name: String = ""
    var description: String = ""
    var category: CommunityCategory = .academic
    var hashtags: [String] = []
    var isPrivate: Bool = false
    var autoApproval: Bool = false
}

struct CommunityDetail: Codable {
    struct Community: Codable {
        var isPrivated: Bool
        var category: String?
        var name: String
        var introduce: String
        var hashtags: [String]?
        var memberCount: String
        var createdAt: String
    }
    struct Notice: Codable, Hashable {
        var id: Int
        var title: String
        var createdAt: String
    }
    struct Post: Codable, Hashable {
        var id: Int
        var content: String
        var createdAt : String
    }
    
    var isJoined: Bool
    var community: Community
    var notices: [Notice]?
    var posts: [Post]?
}

enum Role: String {
    case manager = "MANAGER", subManager = "SUBMANAGER", member = "MEMBER"
    var id: Self { self }
    
    func type() -> String {
        switch self {
        case .manager:
            return "매니저"
        case .subManager:
            return "부매니저"
        case .member:
            return "멤버"
        }
    }
}

struct CommunityMembers: Codable {
    struct Member: Codable, Hashable {
        struct User: Codable, Hashable {
            var id: Int
            var tagNum: String
            var name: String
            var department: String
            var profileImageUrl: String?
        }
        
        var createdAt: String
        var id: Int
        var memberType: String
        var user: User
    }
    struct PageInfo: Codable {
        var nextPage: Int
        var totalCount: Int
        var hasNext: Bool
    }
    
    var pageInfo: PageInfo
    var members: [Member]
}

struct JoinRequests: Codable, Hashable {
    struct Request: Codable, Hashable {
        struct User: Codable, Hashable {
            var id: Int
            var tagNum: String
            var name: String
            var profileImageUrl: String?
        }
        var id: Int
        var user: User
    }
    
    var requests: [Request]
}

struct CommunitySettings: Codable {
    struct Info: Codable {
        var isAuto: Bool
        var isSecret: Bool
    }
    
    var settingInfo: Info
}

struct CommunityBannedMembers: Codable {
    struct Member: Codable, Hashable {
        struct User: Codable, Hashable {
            var id: Int
            var name: String
            var tagNum: String
        }
        
        var memberId: Int
        var user: User
    }
    
    var banned: [Member]
}

struct CommunityMetadata: Codable {
    struct Metadata: Codable {
        var name: String
        var introduce: String
        var hashtags: [String]?
    }
    
    var metadata: Metadata
}
