//
//  FollowMemberCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.
//

import UIKit

class FollowMemberCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FollowMemberCell"
    
    var member : Member? {
        didSet {
            configure(member:self.member)
        }
    }
    
    private var nickNameLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.font = .boldSystemFont(ofSize: 24)
        $0.tintColor = .black
    }
    
    private var emailLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.font = .systemFont(ofSize: 18)
        $0.tintColor = .black
    }
    
    //MARK: - LifeCycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel.snp.left)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
        }
    }
    
    private func configure(member:Member?){
        guard let member = member else {
            return
        }

        nickNameLabel.text = member.nickName
        emailLabel.text = member.email
    }
}
