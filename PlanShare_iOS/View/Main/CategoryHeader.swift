//
//  CetegoryCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit

class CategoryHeader: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseIdentifier = "CategoryCell"
    
    var task: Int = 0 {
        didSet{
            DispatchQueue.main.async {
                self.goalLabel.text = "\(self.task) Task"
            }
        }
    }
    
    private lazy var goalLabel = UILabel().then {
        $0.font = .noto(size: 18, family: .Regular)
        $0.textAlignment = .left
        $0.text = "0 Task"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

