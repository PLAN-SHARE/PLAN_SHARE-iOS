//
//  FollowingMemberCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/29.
//

import UIKit

enum FollowState: Int,CaseIterable {
    case followed = 0
    case unfollowed
    
    var description: String{
        switch self {
        case .followed: return "언팔로우"
        case .unfollowed : return "팔로우"
        }
    }
    
    var color : UIColor {
        switch self {
        case .followed : return UIColor.mainColor
        case .unfollowed : return UIColor.black
        }
    }
}

protocol FollowingMemeberCellDelegate : class {
    func didTapFollow(member:Member,isFollowed:Bool)
}

class FollowingMemberCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FollowingMemberCell"
    
    weak var delegate : FollowingMemeberCellDelegate?
    
    var isFollowed: Bool = true {
        didSet {
            isFollowed ? followButton.setTitle("UnFollowing", for: .normal) : followButton.setTitle("following", for: .normal)
            
            let width = isFollowed ? 70 : 60
            
            followButton.snp.updateConstraints { make in
                make.width.equalTo(width)
            }
        }
    }
    var member : Member? {
        didSet {
            configure(member:self.member)
        }
    }
    
    var followState : FollowState = .followed {
        didSet {
            let color = followState.color
            followButton.setTitle(followState.description, for: .normal)
            followButton.backgroundColor = color
        }
    }
    private var nickNameLabel = UILabel().then {
        $0.backgroundColor = .systemBackground
        $0.font = .boldSystemFont(ofSize: 24)
        $0.tintColor = .black
    }
    
    private var emailLabel = UILabel().then {
        $0.backgroundColor = .systemBackground
        $0.font = .systemFont(ofSize: 18)
        $0.tintColor = .black
    }
    
    private lazy var followButton = UIButton().then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 30/2
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        backgroundColor = .systemBackground
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel.snp.left)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        let ul = UIView()
        ul.backgroundColor = .lightGray
        
        addSubview(ul)
        ul.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configure(member:Member?){
        guard let member = member else {
            return
        }

        nickNameLabel.text = member.nickName
        emailLabel.text = member.email
    }
    
    @objc func didTapFollow(){
        isFollowed.toggle()
        
        guard let member = member else {
            return
        }
        
        delegate?.didTapFollow(member: member,isFollowed: self.isFollowed)
    }
}
