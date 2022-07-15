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

final class GoalViewController: UIViewController {
    
    //MARK: - Properties
    
    let viewModel: GoalViewModel!
    private var disposBag = DisposeBag()
    private var collectionView: UICollectionView!
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
    
    init(viewModel: GoalViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GoalViewCell.self, forCellWithReuseIdentifier: GoalViewCell.reuseIdentifier)
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        let refreshControl = UIRefreshControl()
        refreshControl.endRefreshing()
        collectionView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] _ in
                self?.viewModel.fetchCategory()
                refreshControl.endRefreshing()
            }).disposed(by: disposBag)
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.goalsSubject.bind(to: collectionView.rx.items(cellIdentifier: GoalViewCell.reuseIdentifier, cellType: GoalViewCell.self)) { row, element, cell in
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
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state != .ended {
            return
        }
        
        let location = gesture.location(in: self.collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: location) {
            let cell = collectionView.cellForItem(at: indexPath)
            print("DEBUG :\(indexPath)")
        } else {
            print("couldn't find index path")
        }
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

extension GoalViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }
}
