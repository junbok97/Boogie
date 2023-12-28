//
//  HotPost.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/18.
//

import Foundation

struct HotPost: Codable {
    var postId,likeCount,commentCount,communityId : Int
    var content: String
    var hashtags: [String]?
}
