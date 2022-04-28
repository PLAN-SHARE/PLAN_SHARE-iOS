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
            guard let category = self.category else {
                return
            }
            configure(category: category)
        }
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var goalLabel = UILabel().then {
        $0.font = .noto(size: 18, family: .Regular)
        $0.textAlignment = .left
        $0.text = "목표"
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(category: Category){
        let viewModel = CategoryViewModel(category: category)
        goalLabel.text = "\(viewModel.title!)"
        imageView.image = UIImage(named:viewModel.imageUrl)
        
        let color = UIColor.init(hex: viewModel.textColor)
        imageView.tintColor = color

    }
}

