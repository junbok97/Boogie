//
//  SearchViewController.swift
//  Boogi
//
//  Created by 이준복 on 2022/05/14.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "검색"

    }
    @IBSegueAction func addSwfitUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SearchView())
    }
    
}
