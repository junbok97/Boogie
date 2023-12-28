//
//  HomeListCell.swift
//  Test
//
//  Created by 이준복 on 2022/05/03.
//

import UIKit

class BaseListCell: UITableViewCell {
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(dataType: DataType, data: Any?) {
        switch dataType {
        case .post:
            let post = data as? Post
            titleLabel.text = post?.content
            timeLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: post?.createdAt)
        case .notice:
            let notice = data as? Notice
            titleLabel.text = notice?.title
            timeLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: notice?.createdAt)
        default:
            return
        }
    }
    
}
