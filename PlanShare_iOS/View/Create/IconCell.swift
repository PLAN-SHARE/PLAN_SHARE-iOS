//
//  IconCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/20.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    static let reuseIdentifier = "IconCell"
    
    var icon: String? {
        didSet {
            configure()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? .red : .black
        }
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let icon = icon else {
            return
        }
        imageView.image = UIImage(named:icon)
    }
}
