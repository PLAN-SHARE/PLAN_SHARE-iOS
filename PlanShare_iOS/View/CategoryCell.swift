//
//  CetegoryCell.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    //MARK: - Properties
    
    static let reuseIdentifier = "CategoryCell"
    
    private var scheduleList = ["프로젝트 디자인","프로젝트 설계서 작성","프로젝트 기획서 마감"]
    
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
    private var scheduleCollectionView :UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        backgroundColor = .white
        
        addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(-2)
            make.height.equalTo(60)
            make.width.equalTo(140)
        }
        
        addSubview(scheduleCollectionView)
        scheduleCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(categoryButton.snp.bottom)
            make.height.equalTo(scheduleList.count * 50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        scheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        scheduleCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        scheduleCollectionView.backgroundColor = .white
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.isScrollEnabled = false
    }
}

extension CategoryCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as! ScheduleCell
        return cell
    }
    

}
extension CategoryCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 40)
    }
}
