//
//  DetailGoalViewController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/25.
//

import Foundation
import UIKit

final class DetailGoalViewController: UIViewController {
    
    //MARK: - Properties
    var goal: Goal{
        didSet{
            configure()
        }
    }
    
    var state: GoalFilterOptions = .expected {
        didSet {
            configure()
        }
    }
    
    var schedules: [Schedule] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var collectionView: UICollectionView!
    
    //MARK: - Lifecycle
    init(goal: Goal,schedules:[Schedule]){
        self.goal = goal
        self.schedules = schedules
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configure()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func configure(){
        guard let schedules = goal.schedules else { return }
        
        self.schedules = schedules.filter {
            state.rawValue == Date().compare(convertToDate(date: $0.date)).rawValue
        }
    }
    
    func configureUI(){
        
        navigationItem.title = goal.title
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handleDismissal))
        view.backgroundColor = .mainBackgroundColor
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(DetailGoalViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailGoalViewHeader.reuseIdentifier)
        collectionView.register(DetailGoalListCell.self, forCellWithReuseIdentifier: DetailGoalListCell.reuseIdentifier)
        collectionView.register(DefaultTextCell.self, forCellWithReuseIdentifier: DefaultTextCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .mainBackgroundColor
        
    }
    
    @objc func handleDismissal(){
        dismiss(animated: false)
    }
    
}

extension DetailGoalViewController: UICollectionViewDelegate {
    
}

extension DetailGoalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count == 0 ? 1 : schedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if schedules.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultTextCell.reuseIdentifier, for: indexPath) as? DefaultTextCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailGoalListCell.reuseIdentifier, for: indexPath) as? DetailGoalListCell else { return UICollectionViewCell() }
            cell.schedule = schedules[indexPath.row]
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailGoalViewHeader.reuseIdentifier, for: indexPath) as? DetailGoalViewHeader else {
                return UICollectionReusableView()
            }
            header.goal = goal
            header.delegate = self
            return header
        default :
            fatalError("nope")
        }
    }
}

extension DetailGoalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension DetailGoalViewController: DetailGoalViewHeaderDelegate {
    func filterView(_ view: DetailGoalViewHeader, didSeletect index: Int) {
        state = GoalFilterOptions.allCases[index]
    }
    
    private func convertToDate(date: String) -> Date{
        //        "2022-04-25T00:00:00.09"
        let lastIndex = date.index(date.startIndex, offsetBy: 10)
        let dateFommater = DateFormatter()
        dateFommater.dateFormat = "yyyy/MM/dd"
        
        return dateFommater.date(from: String(date[..<lastIndex]))!
    }
}
