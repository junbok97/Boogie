//
//  Report.swift
//  Boogi
//
//  Created by 이준복 on 2022/04/29.
//

import Foundation

enum ReportReason: String, CaseIterable, Identifiable {
    case sexual = "SEXUAL"
    case swear = "SWEAR"
    case defamation = "DEFAMATION"
    case politics = "POLITICS"
    case commercialAd = "COMMERCIAL_AD"
    case illegal_filming = "ILLEGAL_FILMING"
    case etc = "ETC"
    
    var id: Self { self }
    
    func type() -> String {
        switch self {
        case .sexual:
            return "음란물"
        case .swear:
            return "욕설"
        case .defamation:
            return "명예훼손"
        case .politics:
            return "정치인 비하 및 선거운동"
        case .commercialAd:
            return "상업적 광고"
        case .illegal_filming:
            return "불법 촬영물"
        case .etc:
            return "기타"
        }
    }
}

struct CreateReport {
    var id: Int // id 값
    var target: String // COMMUNITY, POST, COMMENT 중 한개 입력
    var reason: ReportReason = .sexual // 신고 사유
    var content: String = "" // 상세 사유
}
