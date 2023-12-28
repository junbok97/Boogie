//
//  MemberListViewController.swift
//  Test
//
//  Created by 이준복 on 2022/05/10.
//

import UIKit

class MemberListViewController: UIViewController {

    @IBOutlet weak var memberListTableView: UITableView!
    
    let webService = WebService.webService
    let cellFactory = CellFactory.cellFactory
    let vcFactory = ViewControllerFactory.viewControllerFactory
    
    var communityId: Int?
    var members: Members?
    var memberList: [Member]?
    
    var currentPage = 0
    var size = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TitleType.memberList.toString()
        navigationItem.backButtonTitle = ""
        api()
        tableViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
    }
    
}

extension MemberListViewController {
    func configure(id :Int) {
        communityId = id
    }
}


// api()
extension MemberListViewController {
    func api() {
        webService.getCommunityMembers(communityId: communityId!, page: currentPage, size: size) { [weak self] members in
            guard let self = self else {return}
            self.members = members
            self.memberList = members.members
            self.memberListTableView.reloadData()
        }
    }
}

extension MemberListViewController {
    func tableViewSetting() {
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
        memberListTableView.register(UINib(nibName: CellType.memberList.toString(), bundle: nil), forCellReuseIdentifier: CellType.memberList.toString())
    }
}

extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.makeCell(cellType: .memberList, data: memberList?[indexPath.row], tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcFactory.makeViewController(controllerType: .profile, id: memberList?[indexPath.row].user?.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
