//
//  NoticeDetailViewController.swift
//  Test
//
//  Created by 이준복 on 2022/05/05.
//

import UIKit

class NoticeListViewController: UIViewController {

    @IBOutlet weak var noticeTableView: UITableView!
    
    let webService = WebService.webService
    
    var communityId: Int?
    var notices: Notices?
    var cellType: CellType = .appNotice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TitleType.notice.toString()
        navigationItem.backButtonTitle = ""
        api()
        tableViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
    }
    
    func configure(id: Int?) {
        if id != nil {
            communityId = id
            cellType = .communityNotice
        } else {
            cellType = .appNotice
        }
    }
}

extension NoticeListViewController {
    func api() {
        webService.getNotices(communityId: self.communityId) { [weak self] notices in
            guard let self = self else {return}
            self.notices = notices
            self.noticeTableView.reloadData()
        }
    }
}

extension NoticeListViewController {
    func tableViewSetting() {
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.rowHeight = UITableView.automaticDimension
        if communityId == nil {
            cellType = .appNotice
        } else {
            cellType = .communityNotice
        }
        noticeTableView.register(UINib(nibName: cellType.toString(), bundle: nil), forCellReuseIdentifier: cellType.toString())
    }
}

extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices?.notices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.cellType {
        case .appNotice:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.appNotice.toString(), for: indexPath) as? AppNoticeCell else {return UITableViewCell()}
            cell.configure(notice: notices?.notices?[indexPath.row])
            return cell
        case .communityNotice :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.communityNotice.toString(), for: indexPath) as? CommunityNoticeCell else {return UITableViewCell()}
            cell.configure(notice: notices?.notices?[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
