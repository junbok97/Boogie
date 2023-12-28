//
//  API+Alarm.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/21.
//

import Foundation

extension WebService {
    func getAlarms() async throws -> Alarm {
        guard let url = URL(string: "\(base)/alarms") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        var alarms = try JSONDecoder().decode(Alarm.self, from: data)
        
        alarms.alarms.enumerated().forEach({ (index, item) in
            alarms.alarms[index].createdAt = getDateTime(datetime: item.createdAt)
        })
        
        return alarms
    }
    
    func deleteAlarm(alarmId: Int) async throws {
        guard let url = URL(string: "\(base)/alarms/\(alarmId)/delete") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserInfo.userInfo.XAuthToken, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print(try JSONSerialization.jsonObject(with: data))
    }
}
