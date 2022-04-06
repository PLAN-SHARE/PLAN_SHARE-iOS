//
//  FollowingCollectionViewCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/20.
//

import UIKit
import SnapKit
import Then

class FollowingCell: UICollectionViewCell {
    
    //MARK: - Properties
    var member: Member? {
        didSet {
            configure(member: self.member)
        }
    }
    
    static let reuseIdentifier = "FollowingCell"
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = FollowingCell()
//        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 40 / 2
    }
    
    //MARK: - Configure
    private func configureUI() {
        backgroundColor = .systemGroupedBackground
        
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .lightGray
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
        }
    }
    
    private func configure(member: Member?) {
        guard let member = member else {
            return
        }
        titleLabel.text = member.nickName
    }
    
}
