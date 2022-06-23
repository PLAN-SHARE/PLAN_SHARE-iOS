//
//  GoalViewCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/04/27.
//

import UIKit

class GoalViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GoalViewCell"
    
    private lazy var containerView = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemBackground
        
        $0.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)

        }
        
        $0.addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        }
        
        
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "목표"
        $0.font = .noto(size: 16, family: .Regular)
        $0.tintColor = .white
    }
    
    private var percentageLabel = UILabel().then {
        $0.text = "0%"
        $0.font = .noto(size: 18, family: .Regular)
        $0.tintColor = .white
    }
//    
//    private var totalCount = UILabel().then {
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
