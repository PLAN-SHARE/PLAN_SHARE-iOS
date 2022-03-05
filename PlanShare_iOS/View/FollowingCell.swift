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
    
    static let reuseIdentifier = "FollowingCell"
    
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = FollowingCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 40 / 2
    }
    
    private func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .lightGray
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 2
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
}
