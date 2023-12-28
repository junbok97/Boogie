//
//  CommunityInfoCell.swift
//  Test
//
//  Created by 이준복 on 2022/05/06.
//

import UIKit

class CommunityInfoCell: UITableViewCell {
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var memberListButton: UIButton!
    @IBOutlet weak var isPrivateLabel: UILabel!
    
    let createdAtDateFormatter = CreatedAtFormatter.createdAtFormatter
    let vcFatroy = ViewControllerFactory.viewControllerFactory
    
    var navigationVC: UINavigationController?
    var communityId: Int?
    
    func configure(communityId: Int?, communityDetail: CommunityDetail2?, navigationVC: UINavigationController?){
        selectionStyle = .none
        guard let communityDetail = communityDetail else {return}
 
        titleLabel.text = communityDetail.community.name
        contentsLabel.text = communityDetail.community.introduce
        createdAtLabel.text = createdAtDateFormatter.getDateFormatting(createdAt: communityDetail.community.createdAt)

        
        memberListButton.setTitle(communityDetail.community.memberCount, for: .normal)
        var hash = ""
        communityDetail.community.hashtags?.forEach{
            hash = "#\($0) " + hash
        }
        hashTagLabel.text = hash
        if communityDetail.community.isPrivated {
            isPrivateLabel.text = "비공개"
        } else {
            isPrivateLabel.text = "공개"
        }
        categoryLabel.text = CommunityCategory(rawValue: communityDetail.community.category ?? "OTHER")?.type()
        
        self.communityId = communityId
        self.navigationVC = navigationVC
        

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func memberListButtonTapped(_ sender: UIButton) {
        let vc = vcFatroy.makeViewController(controllerType: .memberList, id: communityId)
        navigationVC?.pushViewController(vc, animated: true)
    }
    

}
