//
//  ScheduleCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ScheduleCell"
    
    private let scheduleLabel = UILabel().then {
        $0.text = "프로젝트 기획서 마감"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    }
    
    private let editButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        $0.tintColor = .black
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(scheduleLabel)
        scheduleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        
        addSubview(underline)
        underline.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditButton() {
        print("DEBUG : Did tap EditButton")
    }
    
}
