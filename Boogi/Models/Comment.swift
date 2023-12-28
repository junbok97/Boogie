//
//  Comment.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation



struct Comments: Codable {
    var comments: [Comment]
    var pageInfo: PageInfo
}

struct Comment: Codable {
    var id: Int? // 부모 commentID
    var user: User?
    var member: Member?
    var likeId: Int? // 자기자신이 like 했는지
    var likeCount: Int
    var createdAt: String?
    var content: String
    var me: Bool
    var child: [Comment]?
}

struct CreatedComment: Codable {
    var postId: Int
    var content: String
    var parentCommentId: Int?
    var mentionedUserIds: [Int]?
}
