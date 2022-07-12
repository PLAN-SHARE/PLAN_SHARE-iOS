//
//  FollowingCollectionViewCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/20.
//

import UIKit
import SnapKit
import Then

final class FollowingCell: UICollectionViewCell {
    
    //MARK: - Properties
    var member: Member? {
        didSet {
            DispatchQueue.main.async {
                self.configure(member: self.member)
            }
        }
    }
    
    static let reuseIdentifier = "FollowingCell"
    
    private var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .noto(size: 14, family: .Regular)
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.height / 2
    }
    
    //MARK: - Configure
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .mainColor
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configure(member: Member?) {
        guard let member = member else {
            return
        }
        titleLabel.text = member.nickName
    }
    
}
