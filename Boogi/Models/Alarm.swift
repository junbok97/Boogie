//
//  Alarm.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation

struct Alarm: Codable {
    struct Content: Codable, Hashable {
        var id: Int
        var head: String
        var body: String?
        var createdAt: String
    }
    
    var alarms: [Content]
}
