//
//  Search.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation

enum Ordering: String {
    case newer = "NEWER", older = "OLDER", likeUpper = "LIKE_UPPER", manyPeople = "MANY_PEOPLE", lessPeople = "LESS_PEOPLE"
    // var id: Self { self }
    
    func type() -> String {
        switch self {
        case .newer:
            return "최신순"
        case .older:
            return "오래된 순"
        case .likeUpper:
            return "좋아요 순"
        case .manyPeople:
            return "인원 많은 순"
        case .lessPeople:
            return "인원 적은 순"
        }
    }
}

struct CommunitySearchResult: Codable {
    struct Community: Codable, Hashable {
        var id: Int
        var name: String
        var description: String
        var createdAt: String
        var hashtags: [String]?
        var memberCount: Int
        var category: String
        var `private`: Bool
    }
    struct Page: Codable {
        var nextPage: Int
        var totalCount: Int
        var hasNext: Bool
    }
    
    var communities: [CommunitySearchResult.Community]
    var pageInfo: CommunitySearchResult.Page
}

struct PostSearchResult: Codable {
    struct Post: Codable, Hashable {
        struct User: Codable, Hashable {
            var id: Int
            var name: String
            var tagNum: String
            var profileImageUrl: String?
        }
        
        var id: Int
        var user: PostSearchResult.Post.User
        var communityId: Int
        var communityName: String
        var createdAt: String
        var hashtags: [String]?
        var commentCount: Int
        var likeCount: Int
        var content: String
    }
    struct Page: Codable {
        var nextPage: Int
        var totalCount: Int
        var hasNext: Bool
    }
    
    var posts: [PostSearchResult.Post]
    var pageInfo: PostSearchResult.Page
}

struct SearchParameter {
    enum isPrivate {
        case all
        case `private`
        case `public`
        
        func type() -> String {
            switch self {
            case .all: return "전체"
            case .private: return "비공개"
            case .public: return "공개"
            }
        }
    }
    
    var isPrivate: isPrivate = .all
    var order: Ordering = .newer
    var category: CommunityCategory = .all
    var keyword: String = ""
}
