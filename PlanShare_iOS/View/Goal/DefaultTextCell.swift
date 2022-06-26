//
//  DefaultTextCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/26.
//

import UIKit

class DefaultTextCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DefaultTextCell"

    private var label = UILabel().then{
        $0.text = "등록된 일정이 없습니다.\n 새로운 일정을 추가하고 완료하세요!"
        $0.font = .noto(size: 18, family: .Regular)
        $0.textColor = .darkGray
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
