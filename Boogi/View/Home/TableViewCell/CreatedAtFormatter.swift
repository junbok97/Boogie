//
//  CreatedAtFormatter.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/26.
//

import Foundation

class CreatedAtFormatter {
    
    static let createdAtFormatter = CreatedAtFormatter()
    
    func getDateFormatting(createdAt: String?) -> String {
        guard let createdAt = createdAt else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: createdAt) {
            let mydate = DateFormatter()
            mydate.dateFormat = "yy.MM.dd HH:mm"
            let convertStr = mydate.string(from: date)
            return convertStr
        } else {
            return ""
        }
    }
}
