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

class FollowController: UIViewController {
    
    //MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    private var disposeBag = DisposeBag()
    
    private var viewModel: FollowViewModel!
    
    private var memberSubject = BehaviorRelay<[FollowSectionModel]>(value: [])
    
    private var selectedFilter: FollowFilterOptions = .follower {
        didSet { self.fetchSectionModel(options: self.selectedFilter) }
    }
    
    private lazy var label = UILabel().then{
        $0.text = "\(selectedFilter.description)중인 유저가 없습니다."
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
    }
    
    //MARK: - LifeCycle
    init(viewModel:FollowViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        fetchSectionModel(options: self.selectedFilter)
        bind()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Configure
    func configureNavigationBar(){
        navigationItem.title = "팔로우"
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:.plain, target: self, action:#selector( handleDissmissal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddFollow))
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 50)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(FollowMemberCell.self, forCellWithReuseIdentifier: FollowMemberCell.reuseIdentifier)
        collectionView.register(FollowFilterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FollowFilterView.reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    
    private func bind() {
        label.isHidden = memberSubject.value.count == 0 ? true : false

        let dataSource = RxCollectionViewSectionedReloadDataSource<FollowSectionModel> { dataSource, collectionView, indexPath, Item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowMemberCell.reuseIdentifier, for: indexPath) as? FollowMemberCell else {
                return UICollectionViewCell()
            }
            cell.member = Item
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FollowFilterView.reuseIdentifier, for: indexPath) as! FollowFilterView
            header.delegate = self
            return header
        }
        
        memberSubject.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    private func fetchSectionModel(options:FollowFilterOptions){
        viewModel.fetchFollow(option: options)
            .subscribe(onNext : {
                self.memberSubject.accept($0)
            }).disposed(by: disposeBag)
        
    }

//MARK: - Selector
    @objc func handleAddFollow(){
        let vc = SearchController()
        navigationController?.pushViewController(vc, animated: false)
    }
    @objc func handleDissmissal(){
        navigationController?.popViewController(animated: false)
    }
}
extension FollowController : FollowFilterViewDelegate {
    func filterView(_ view: FollowFilterView, didSeletect index: Int) {
        guard let filter = FollowFilterOptions(rawValue: index) else { return }
        selectedFilter = filter
    }
    
    
}
