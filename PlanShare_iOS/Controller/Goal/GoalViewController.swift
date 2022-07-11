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
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GoalViewCell.self, forCellWithReuseIdentifier: GoalViewCell.reuseIdentifier)
        collectionView.delegate = nil
        collectionView.dataSource = nil
//        setupLongGestureRecognizerOnCollection()
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
    
    //    func setupLongGestureRecognizerOnCollection() {
    //        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    //        longPressedGesture.minimumPressDuration = 0.5
    //        longPressedGesture.delegate = self
    //        longPressedGesture.delaysTouchesBegan = true
    //        collectionView?.addGestureRecognizer(longPressedGesture)
    //    }
    //
    //    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    //
    //        let location = gestureRecognizer.location(in: collectionView)
    //
    //        if gestureRecognizer.state == .began {
    //
    //            if let indexPath = collectionView.indexPathForItem(at: location) {
    //                print("Long press at item began: \(indexPath.row)")
    //
    //                // animation
    //                UIView.animate(withDuration: 0.2) {
    //                    if let cell = self.collectionView.cellForItem(at: indexPath) as? GoalViewCell {
    //                        self.currentLongPressedCell = cell
    //                        cell.transform = .init(scaleX: 0.95, y: 0.95)
    //                    }
    //                }
    //            }
    //        }
    //
    //        let p = gestureRecognizer.location(in: collectionView)
    //
    //        if let indexPath = collectionView?.indexPathForItem(at: p) {
    //            print("Long press at item: \(indexPath.row)")
    //        }
    //    }
    
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
//    private func setupLongGestureRecognizerOnCollection() {
//
//        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
//        longPressedGesture.minimumPressDuration = 0.5
//        longPressedGesture.delegate = self
//        longPressedGesture.delaysTouchesBegan = true
//        collectionView.addGestureRecognizer(longPressedGesture)
//    }
}
