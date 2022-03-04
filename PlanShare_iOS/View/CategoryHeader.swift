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
    
    var category : Category? {
        didSet{
            guard let category = category else {
                return
            }

            configure(category: category)
        }
    }
    
    private var categoryButton = UIButton().then {
        $0.setTitle(" 프로젝트", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 24)
        $0.setTitleColor(.orange, for: .normal)
        $0.setImage(UIImage(systemName: "note.text"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .left
        $0.tintColor = .orange
        $0.backgroundColor = .white
        $0.semanticContentAttribute = .forceLeftToRight
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.width.equalTo(140)
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(category: Category){
        categoryButton.setTitle(category.title, for: .normal)
    }
}

