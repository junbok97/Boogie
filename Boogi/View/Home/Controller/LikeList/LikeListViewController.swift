//
//  LikeListViewController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/27.
//

import UIKit

class LikeListViewController: UIViewController {
    @IBOutlet weak var likeListTableView: UITableView!
    
    let webService = WebService.webService
    let cellFactory = CellFactory.cellFactory
    let vcFactory = ViewControllerFactory.viewControllerFactory
    
    var listType: ListType?
    var id: Int?
    
    var members: [LikeList.User]?
    
    var currentPage = 0
    let size = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TitleType.likeList.toString()
        navigationItem.backButtonTitle = ""
        api()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        api()
        tableViewSetting()
    }
    
    func configure(listType: ListType, id: Int) {
        self.id = id
        self.listType = listType
    }

}

extension LikeListViewController {
    
    func api() {
        
        guard let id = self.id else {return}
        
        if listType == .post {
            webService.getPostLikeList(id: id, of: currentPage, size: size) { [weak self] likeList in
                guard let self = self else {return}
                self.members = likeList.members
                self.likeListTableView.reloadData()
            }
        } else {
            webService.getCommentLikeList(id: id, of: currentPage, size: size) { [weak self] likeList in
                guard let self = self else {return}
                self.members = likeList.members
                self.likeListTableView.reloadData()
            }
        }
    }
    
}

extension LikeListViewController {
    func tableViewSetting() {
        likeListTableView.delegate = self
        likeListTableView.dataSource = self
        likeListTableView.rowHeight = UITableView.automaticDimension
        likeListTableView.register(UINib(nibName: CellType.likeList.toString(), bundle: nil), forCellReuseIdentifier: CellType.likeList.toString())
    }
}

extension LikeListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellFactory.makeCell(cellType: .likeList, data: members?[indexPath.row], tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcFactory.makeViewController(controllerType: .profile, id: members?[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }


}
