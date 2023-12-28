//
//  HotListCell.swift
//  Test
//
//  Created by 이준복 on 2022/05/03.
//

import UIKit

class HotListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with hotPost: HotPost?) {
        selectionStyle = .none
        titleLabel.text = hotPost?.content
        likeButton.setTitle(String(hotPost?.likeCount ?? 0), for: .normal)
        commentButton.setTitle(String(hotPost?.commentCount ?? 0), for: .normal)
    }
}
