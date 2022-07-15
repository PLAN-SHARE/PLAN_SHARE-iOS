//
//  FollowController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

final class FollowController: UIViewController {
    
    //MARK: - Properties
    private var collectionView: UICollectionView!
    private var disposeBag = DisposeBag()
    private var followFilterView = FollowFilterView()
    private var viewModel: FollowViewModel!
    private var memberSubject = BehaviorRelay<[FollowSectionModel]>(value: [])
    
    private var selectedFilter: FollowFilterOptions = .follower {
        didSet { self.fetchSectionModel(options: self.selectedFilter) }
    }
    
    //MARK: - LifeCycle
    init(viewModel:FollowViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("dismissCreateView"),
            object: nil
        )
        
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchSectionModel(options: self.selectedFilter)
        bind()
    }
    
    //MARK: - Configure
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(followFilterView)
        followFilterView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(followFilterView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigationBar(){
        navigationItem.title = "팔로우"
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:.plain, target: self, action:#selector( handleDissmissal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddFollow))
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureCollectionView() {
        followFilterView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 65)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(FollowerMemeberCell.self, forCellWithReuseIdentifier: FollowerMemeberCell.reuseIdentifier)
        collectionView.register(FollowingMemberCell.self, forCellWithReuseIdentifier: FollowingMemberCell.reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    //MARK: - binding,Fetch
    private func bind() {

        let dataSource = RxCollectionViewSectionedReloadDataSource<FollowSectionModel> { dataSource, collectionView, indexPath, Item in
            switch self.selectedFilter {
            case .following :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingMemberCell.reuseIdentifier, for: indexPath) as? FollowingMemberCell else {
                    return UICollectionViewCell()
                }
                cell.member = Item
                cell.delegate = self
                return cell
            case .follower:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerMemeberCell.reuseIdentifier, for: indexPath) as? FollowerMemeberCell else {
                    return UICollectionViewCell()
                }
                cell.member = Item
                
                return cell
            }
        }
        
        memberSubject.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func fetchSectionModel(options:FollowFilterOptions){
        viewModel.fetchFollow(option: options)
            .subscribe(onNext : {
                self.memberSubject.accept($0)
                print($0)
            }).disposed(by: disposeBag)
        
    }
    

    //MARK: - Selector
    @objc func handleAddFollow(){
        let vc = SearchController(viewModel: SearchViewModel(userService: UserService(), categoryService: CategoryService()))
        navigationController?.pushViewController(vc, animated: false)
    }
    @objc func handleDissmissal(){
        navigationController?.popViewController(animated: false)
    }
    @objc func didDismissDetailNotification(_ notification: Notification) {
        fetchSectionModel(options: selectedFilter)
    }
}

//MARK: - FollowFilterViewDelegate
extension FollowController : FollowFilterViewDelegate {
    func filterView(_ view: FollowFilterView, didSeletect index: Int) {
        guard let filter = FollowFilterOptions(rawValue: index) else { return }
        selectedFilter = filter
    }
}

//MARK: - FollowingMemeberCellDelegate
extension FollowController : FollowingMemeberCellDelegate {
    func didTapFollow(member: Member, isFollowed: Bool) {
//        
    }
    
//    func didTapFollow(member: Member, isFollowed: Bool) {
//        viewModel.handleFollow(member: member, isFollwed: isFollowed)
//    }
}
