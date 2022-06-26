//
//  DetailViewController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/24.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator

class GoalViewController: UIViewController {
    
    //MARK: - Properties
    
    let viewModel = GoalViewModel(categoryService: CategoryService(), scheduleService: ScheduleService())
    
    private var disposBag = DisposeBag()
    
    private var collectionView: UICollectionView!
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .noto(size: 20, family: .Bold)
        $0.textAlignment = .center
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
        
        configureNavigation()
        
        configureCollectionView()
        configureUI()
        bind()
    }
    
    //MARK: - Configure
    func configureNavigation() {
        navigationItem.title = "목표"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addGoal))
    }
    
    func configureUI(){
        view.backgroundColor = .mainBackgroundColor
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GoalViewCell.self, forCellWithReuseIdentifier: GoalViewCell.reuseIdentifier)
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    func bind() {

        viewModel.fetchCategory()
            .bind(to: collectionView.rx.items(cellIdentifier: GoalViewCell.reuseIdentifier, cellType: GoalViewCell.self)) { row, element, cell in
                cell.goal = element
            }.disposed(by: disposBag)
    
        collectionView.rx.modelSelected(Goal.self)
            .subscribe(onNext: { [weak self] product in
                guard let schedules = product.schedules else { return }
                let vc = UINavigationController(rootViewController: DetailGoalViewController(goal: product,schedules: schedules))
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc,animated: false)
            }).disposed(by: disposBag)
    }
    
    @objc func addGoal(){
        let vc = CreateCategoryController(viewModel: CreateViewModel(categoryService: CategoryService(), scheduleService: ScheduleService()))
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        bind()
    }
}
