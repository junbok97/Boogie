//
//  ReportCreateView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/05.
//

import Foundation
import SwiftUI

struct ReportCreateView: View {
    @State var createReport: CreateReport
    @State var alertPresent = false
    @State var newTag = ""
    
    @Binding var reporting: Bool
    
    var body: some View {
        NavigationView {
        VStack {
            Form {
                Section("사유") {
                    Picker("사유", selection: $createReport.reason) {
                        ForEach(ReportReason.allCases, id: \.self) { reason in
                            Text(reason.type())
                        }
                    }
                }
                
                Section("상세") {
                    TextEditor(text: $createReport.content)
                        .frame(height: 150, alignment: .topLeading)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button {
                    Task {
                        do {
                            try await WebService.webService.postReport(form: createReport)
                            reporting = false
                        } catch {
                            
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("생성하기")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .background(.red.opacity(0.8))
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    }
}
