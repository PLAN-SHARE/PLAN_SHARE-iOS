//
//  SearchUserCell.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/29.
//

import UIKit

protocol SearchUserCellDelegate: class {
    func handleFollow(member:Member,isFollow:Bool)
}
class SearchUserCell: UITableViewCell {

    static let reuseIdentifier = "SearchUserCell"
    
    weak var delegate : SearchUserCellDelegate?
    
    var member : MemberResponse? {
        didSet {
            configure(member:self.member)
        }
    }
    
    var isFollow : Bool = false {
        didSet {
            let title = self.isFollow ? "언팔로잉" : "팔로잉"
            followButton.setTitle(title, for: .normal)
            let width = isFollow ? 70 : 60
            followButton.snp.updateConstraints { make in
                make.width.equalTo(width)
            }
        }
    }
    private var nickNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.tintColor = .black
    }
    
    private var emailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.tintColor = .lightGray
    }
    
    private lazy var followButton = UIButton().then {
        $0.setTitle("Follow", for: .normal)
        $0.backgroundColor = .black
        $0.tintColor = .white
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 40/2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.addTarget(self, action: #selector(HandlefollowUnfollow), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Configure
    private func configureUI(){
        backgroundColor = .white

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

        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(nickNameLabel.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

    }
    
    private func configure(member:MemberResponse?){
        guard let member = member else {
            return
        }
        
        nickNameLabel.text = member.member.nickName
        emailLabel.text = member.member.email
        isFollow = member.status
    }

    @objc func HandlefollowUnfollow(){
        guard let member = member else {
            return
        }
        isFollow.toggle()
        delegate?.handleFollow(member: member.member, isFollow: self.isFollow)
    }

}
