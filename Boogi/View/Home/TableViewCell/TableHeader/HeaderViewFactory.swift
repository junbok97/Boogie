//
//  HeaderViewFactory.swift
//  Test
//
//  Created by 이준복 on 2022/05/06.
//

import Foundation
import SnapKit
import Kingfisher
import UIKit

class HeaderViewFactory: UIViewController {
    
    static let headerViewFactory = HeaderViewFactory()
    
    func makeHeaderView(headertype: HeaderType, title: TitleType) -> UIView {
        let headerframe = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        let headerView = UIView(frame: headerframe)
        let titleLabel = UILabel()
        
        headerView.contentMode = .scaleAspectFit
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = .white
        titleLabel.text = title.toString()
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.equalToSuperview().offset(10)
            $0.bottom.trailing.equalToSuperview().offset(-10)
        }
        
        switch headertype {
        case .title:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        case .comment:
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.textAlignment = .center
            headerView.backgroundColor = .systemGray6
            headerView.layer.cornerRadius = 10
        }
        return headerView
    }
    
}
