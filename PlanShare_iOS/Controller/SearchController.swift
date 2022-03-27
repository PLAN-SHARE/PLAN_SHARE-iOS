//
//  SearchController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/18.
//

import UIKit

class SearchController: UIViewController {

    //MARK: - Properties
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        configureTable()
    }
    
    //MARK: - configure
    func configureUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func configureSearch(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.title = "search"
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func configureTable(){
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
