//
//  MemberListCell.swift
//  Test
//
//  Created by 이준복 on 2022/05/10.
//

import UIKit

class MemberListCell: UITableViewCell {


    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagNumLabel: UILabel!
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var memberTypeLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(member: Member?) {
        selectionStyle = .none
        guard let member = member else {return}
        user = member.user
        userNameLabel.text = member.user?.name
        userDepartmentLabel.text = member.user?.department
        userTagNumLabel.text = member.user?.tagNum
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: member.createdAt)
        memberTypeLabel.text = MemberType(rawValue: member.memberType)?.type()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2

        let imageURL = URL(string: member.user?.profileImageUrl ?? "")
        userProfileImageView.kf.setImage(with: imageURL,placeholder: UIImage(systemName: "person.fill"))
        userProfileImageView.contentMode = .scaleAspectFill
    }
    
}
