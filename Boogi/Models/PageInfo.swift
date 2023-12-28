//
//  PageInfo.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/22.
//

import Foundation

struct PageInfo: Codable, Hashable {
    var nextPage: Int
    var totalCount: Int
    var hasNext: Bool
}
