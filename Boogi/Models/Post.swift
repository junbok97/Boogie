//
//  Post.swift
//  Boogi
//
//  Created by 김덕환 on 2022/03/29.
//

import Foundation


struct CreatePost: Codable {
    var communityId: Int = -1
    var content: String = ""
    var hashtags: [String] = []
    var postMediaIds: [String] = []
}

struct Posts: Codable {
    var posts: [Post]
    var pageInfo: PageInfo
}

struct Post: Codable, Hashable{
    var id: Int?
    var createdAt: String?
    var hashtags: [String]?
    var content: String?
    var likeCount: Int?
    var commentCount: Int?
    var me: Bool?
    var user: User?
    var member: Member?
    var community: Community?
    var likeId: Int?
    var postMedias: [PostMedias]?
    
    struct Community: Codable, Hashable{
        var id: Int
        var name: String
    }
    
    struct PostMedias: Codable, Hashable {
        var type: String
        var url: String
    }
}

struct PostDetail: Codable {
    var id: Int
    var user: User
    var member: Member
    var community: Community
    var likeId: Int?
    var createdAt: String
    var content: String
    var hashtags: [String]
    var likeCount: Int
    var commentCount: Int
    var me: Bool
    var postMedias: PostMedias?
    
    struct Community: Codable {
        var id: Int
        var name: String
    }
    struct PostMedias: Codable {
        var type: String
        var url: String
    }
}
