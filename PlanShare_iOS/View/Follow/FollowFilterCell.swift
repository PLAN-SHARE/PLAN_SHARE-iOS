//
//  FollowFilterCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.

import UIKit

enum FollowFilterOptions: Int,CaseIterable {
    case follower = 0
    case following
    
    var description: String{
        switch self {
        case .follower: return "팔로워"
        case .following : return "팔로잉"
        }
    }
    
    var color : UIColor {
        
        switch self {
        case .follower : return UIColor.mainColor
        case .following : return UIColor.black
        }
    }
}

class FollowFilterCell: UICollectionViewCell {
    
    //MARK: - Property
    static let reuseIdentifier = "FollowFilterCell"
    
    var option : FollowFilterOptions! {
        didSet{ titleLabel.text = option.description }
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
