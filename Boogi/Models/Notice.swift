//
//  Notice.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation

struct Notices:Codable {
    var manager: Bool?
    var notices: [Notice]?
}

struct Notice: Codable, Hashable {
    var id: Int
    let title: String
    var createdAt: String
    var content: String?
    var user: User?
}
