//
//  SearchController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/18.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchController: UIViewController {

    //MARK: - Properties
    private var tableView : UITableView!
    
    private var resultSubject = BehaviorRelay<[MemberResponse]>(value: [])
    
    private var disposeBag = DisposeBag()
    private var searchBar = CustomSearchBar()
    private let viewModel : SearchViewModel!
    
    //MARK: - LifeCycle
    init(viewModel: SearchViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        bind()
        fetchData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("dismissCreateView"), object: nil, userInfo: nil)
    }
    
    //MARK: - configure
    private func configureUI() {
        view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds)
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.reuseIdentifier)
        tableView.backgroundColor = .white
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Configure
    private func configureSearch(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismissal))
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = .black
        searchBar.placeholder = "email로 유저를 검색하세요"
    }
    
    private func bind(){
        
        resultSubject
            .bind(to: tableView.rx.items(cellIdentifier:SearchUserCell.reuseIdentifier, cellType: SearchUserCell.self)) { (index: Int, element: MemberResponse?, cell: SearchUserCell) in
                cell.member = element
                cell.delegate = self
        }.disposed(by: disposeBag)
    }
    
    private func fetchData(){
        searchBar.shouldLoadResult
            .subscribe(onNext : {
                self.viewModel.search(text: $0)
                    .subscribe(onNext : {
                        self.resultSubject.accept($0)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: false)
    }
}

//MARK: - SearchUserCellDelegate
extension SearchController : SearchUserCellDelegate {
    func handleFollow(member: Member, isFollow: Bool) {
        viewModel.handleFollow(member: member, isFollow: isFollow)
            .subscribe {
                self.resultSubject.accept($0)
            }.disposed(by: disposeBag)
    }
}
