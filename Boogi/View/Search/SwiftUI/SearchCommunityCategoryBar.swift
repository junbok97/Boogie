//
//  CommunityCategoryBar.swift
//  Boogi
//
//  Created by 김덕환 on 2022/04/19.
//

import Foundation
import SwiftUI

struct SearchCommunityCategoryBar: View {
    @Binding var category: CommunityCategory
    
    var body: some View {
        HStack {
            Button {
                category = .all
            } label: {
                Text(CommunityCategory.all.type())
            }
            .foregroundColor(category == .all ? .blue : .black)
            
            Button {
                category = .academic
            } label: {
                Text(CommunityCategory.academic.type())
            }
            .foregroundColor(category == .academic ? .blue : .black)
            
            Button {
                category = .club
            } label: {
                Text(CommunityCategory.club.type())
            }
            .foregroundColor(category == .club ? .blue : .black)
            
            Button {
                category = .hobby
            } label: {
                Text(CommunityCategory.hobby.type())
            }
            .foregroundColor(category == .hobby ? .blue : .black)
            
            Button {
                category = .other
            } label: {
                Text(CommunityCategory.other.type())
            }
            .foregroundColor(category == .other ? .blue : .black)
            
            Spacer()
        }
        .padding([.leading, .trailing])
    }
}
