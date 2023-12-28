//
//  Server.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/30.
//

import Foundation

struct ServerMessage: Codable {
    let statusCode: Int
    let code: String
    let message: String
    let timestamp: String
}

struct PostSuccess: Codable {
    let id: Int
}

struct Param: Codable {
    var page: Int
    var size: Int
}
