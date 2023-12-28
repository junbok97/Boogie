//
//  PostProgressView.swift
//  Boogi
//
//  Created by 김덕환 on 2022/05/30.
//

import Foundation
import SwiftUI

struct PostProgressView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width + 10000, height: UIScreen.main.bounds.height + 10000)
            
            ProgressView("포스팅...")
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width + 10000, height: UIScreen.main.bounds.height + 10000)
        }
    }
}
