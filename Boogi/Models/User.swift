//
//  User.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation

struct User: Codable,Hashable {
    var id: Int?
    var name: String?
    var tagNum: String?
    var introduce: String?
    var department: String?
    var profileImageUrl: String?
}




struct Profile: Codable {
    let user: User
    let me: Bool
    var post: ProfilePost?
    var comment: ProfileComment?
}

struct ProfilePost: Codable {
    let id: Int
    let content: String
    let createdAt: String
    let community: Community
    let hashtags: [String]?
    let postMedias : [PostMedia]?
    
    struct PostMedia: Codable {
        let url: String
        let type: String
    }
    struct Community: Codable {
        let id: Int
        let name: String
    }
}

struct ProfilePostList: Codable {
    var posts: [ProfilePost]
    var pageInfo: PageInfo
}


struct ProfileComment: Codable {
    let content: String
    let createdAt: String
    let postId: Int
}

struct ProfileCommentList: Codable {
    var comments: [ProfileComment]
    var pageInfo: PageInfo
}

struct JoinCommunity: Codable {
    var communities: [Community]
    struct Community: Codable{
        var id: Int
        var name: String
        var post: Post?
    }
}
