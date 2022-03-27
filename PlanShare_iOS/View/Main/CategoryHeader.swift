//
//  CetegoryCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit


protocol CategoryHeaderDelegate {
    func handleCategory(category:Category)
}

class CategoryHeader: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseIdentifier = "CategoryCell"
    
    var delegate: CategoryHeaderDelegate?
    
    var category : Category? {
        didSet{
            guard let category = self.category else {
                return
            }
            configure(category: category)
        }
    }
    
    private lazy var categoryButton = UIButton().then {
        $0.setTitle(" 프로젝트", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 22)
        $0.setTitleColor(.orange, for: .normal)
        $0.setImage(UIImage(systemName: "note.text"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .left
        $0.tintColor = .black
        $0.backgroundColor = .systemGroupedBackground
        $0.semanticContentAttribute = .forceLeftToRight
        $0.addTarget(self, action: #selector(didTapCategory), for: .touchUpInside)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(category: Category){
        let viewModel = CategoryViewModel(category: category)
        categoryButton.setTitle(" \(viewModel.title!)", for: .normal)
        
        let color = UIColor.init(hex: viewModel.textColor)
        categoryButton.setTitleColor(color, for: .normal)
        categoryButton.tintColor = color
        categoryButton.setImage(UIImage(named:viewModel.imageUrl), for: .normal)

    }
    @objc func didTapCategory(){
        guard let category = category else {
            return
        }

        delegate?.handleCategory(category: category)
    }
}

