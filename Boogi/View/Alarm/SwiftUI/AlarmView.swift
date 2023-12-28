//
//  AlarmView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/06.
//

import Foundation
import SwiftUI

struct AlarmView: View {
    @State var alarms: Alarm = Alarm(alarms: [])
    
    struct AlarmCell: View {
        let alarm: Alarm.Content
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(alarm.head)
                    Text(alarm.body ?? "")
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(alarm.createdAt)
                        .font(.caption)
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets())
            .padding()
        }
    }
    
    var body: some View {
        List {
            ForEach(alarms.alarms, id: \.self) { alarm in
                AlarmCell(alarm: alarm)
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button(role: .destructive) {
//                            Task {
//                                do {
//                                    try await WebService.webService.deleteAlarm(alarmId: alarm.id)
//                                    alarms.alarms.removeAll { $0.id == alarm.id }
//                                } catch {
//                                }
//                            }
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
            }
            .onDelete { offsets in
                offsets.forEach { i in
                    let removed = alarms.alarms.remove(at: i)
                    Task {
                        try await WebService.webService.deleteAlarm(alarmId: removed.id)
                    }
                }
            }
        }
        .animation(.default, value: alarms.alarms.count)
        .task {
            do {
                alarms = try await WebService.webService.getAlarms()
            } catch {
                
            }
        }
    }
}
