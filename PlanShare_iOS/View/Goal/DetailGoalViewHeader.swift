//
//  DetailGoalViewHeader.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/25.
//

import Foundation
import UIKit

protocol DetailGoalViewHeaderDelegate: class {
    func filterView(_ view: DetailGoalViewHeader,didSeletect index: Int)
}

final class DetailGoalViewHeader: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseIdentifier = "DetailGaolViewHeader"
    
    var goal: Goal? {
        didSet {
            configure()
        }
    }
    
    private var collectionView: UICollectionView!
    
    weak var delegate: DetailGoalViewHeaderDelegate?
    
    private var progressBar = DetailCircleProgressView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    
    private var incompletedLabel = UILabel().then{
        $0.text = "미완료"
        $0.textColor = .lightGray
        $0.font = .noto(size: 18, family: .Regular)
    }
    
    private var completedLabel = UILabel().then {
        $0.text = "완료"
        $0.textColor = .lightGray
        $0.font = .noto(size: 18, family: .Regular)
    }
    
    private lazy var completedSchedule = UILabel().then {
        $0.text = "0"
        $0.textColor = .black
        $0.font = .noto(size: 18, family: .Regular)
    }
    
    private lazy var incompletedSchedule = UILabel().then {
        $0.text = "0"
        $0.textColor = .black
        $0.font = .noto(size: 18, family: .Regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureCollectionView()
        configureUI()
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        guard let goal = goal else {
            return
        }

        guard let schedule = goal.schedules else {
            return
        }
        progressBar.goal = goal
        incompletedSchedule.text = String(schedule.count - goal.doneSchedule)
        completedSchedule.text = String(goal.doneSchedule)
    }
     
        
    
    //MARK: - configure
    private func configureUI(){
        backgroundColor = .white
        
        addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        let completedStackView = UIStackView(arrangedSubviews: [completedSchedule,completedLabel])
        completedStackView.axis = .vertical
        completedStackView.spacing = 5
        completedStackView.distribution = .equalCentering
        completedStackView.alignment = .center
        
        let incompletedStackView = UIStackView(arrangedSubviews: [incompletedSchedule,incompletedLabel])
        incompletedStackView.axis = .vertical
        incompletedStackView.spacing = 5
        incompletedStackView.distribution = .fillEqually
        incompletedStackView.alignment = .center
        
        let infoStackView = UIStackView(arrangedSubviews: [completedStackView,incompletedStackView])
        infoStackView.axis = .horizontal
        infoStackView.spacing = 40
        completedStackView.distribution = .equalSpacing
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.register(GoalFilterCell.self, forCellWithReuseIdentifier: GoalFilterCell.reuseIdentifier)
        collectionView.backgroundColor = .mainBackgroundColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //초기에 indexPath(0,0)을 선택하도록 설정.
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
    }
    
    
}
//MARK: - UICollectionViewDataSource
extension DetailGoalViewHeader : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FollowFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalFilterCell.reuseIdentifier, for: indexPath) as? GoalFilterCell else {
            return UICollectionViewCell()
        }
        
        let option = GoalFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailGoalViewHeader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        UIView.animate(withDuration: 0.3) {
            self.delegate?.filterView(self, didSeletect: indexPath.row)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailGoalViewHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 40, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}

