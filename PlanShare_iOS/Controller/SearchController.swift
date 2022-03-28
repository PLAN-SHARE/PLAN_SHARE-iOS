//
//  SearchController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/18.
//

import UIKit
import RxCocoa
import RxSwift

class SearchController: UIViewController, UISearchControllerDelegate {

    //MARK: - Properties
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    private var inputText = BehaviorRelay<String?>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        configureTable()
    }
    
    //MARK: - configure
    private func configureUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func configureSearch(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "email로 유저를 검색해주세요"
        searchController.delegate = self
//        tableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func configureTable(){
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    
}

extension SearchController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
