//
//  FollowFilterCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.

import UIKit

enum GoalFilterOptions: Int,CaseIterable {
    case expected = 0
    case past
    
    var description: String{
        switch self {
        case .expected: return "예정"
        case .past: return "지난"
        }
    }
}

final class GoalFilterCell: UICollectionViewCell {
    
    //MARK: - Property
    static let reuseIdentifier = "GoalFilterCell"
    
    var option : GoalFilterOptions! {
        didSet{ titleLabel.text = option.description }
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .white : .darkGray
            contentView.backgroundColor = isSelected ? .darkGray : .white
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: -2, height: 2)
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
