//
//  NoticeDetailCell.swift
//  Test
//
//  Created by 이준복 on 2022/05/05.
//

import UIKit

class AppNoticeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(notice: Notice?) {
        selectionStyle = .none
        titleLabel.text = notice?.title
        contentLabel.text = notice?.content
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: notice?.createdAt)
    }
    
}
