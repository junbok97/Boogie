//
//  API+Report.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/21.
//

import Foundation

extension WebService {
    func postReport(form: CreateReport) async throws -> Void {
        guard let url = URL(string: "\(base)/reports/") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: auth)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "id" : form.id,         // id 값
            "target" : form.target,   // COMMUNITY, POST, COMMENT, MESSAGE 중 한개 입력
            "reason" : form.reason.rawValue,   // 신고 사유
            "content" : form.content   // 상세 사유
        ])
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
