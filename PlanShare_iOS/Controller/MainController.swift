//
//  ViewController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/20.
//

import UIKit
import FSCalendar

class MainController: UIViewController {
    
    //MARK: - Properties
    private var followingCollectionView : UICollectionView!
    private var scheduleCollectionView : UICollectionView!
    
    private var calendarView = CalendarView(frame: .zero)
    
    private var following = ["박도윤","창묵","호성","희중","가나","다라","하하하","+"]
    
    private var isFloating : Bool = false
    
    private lazy var AddButtons = [UIButton]()
    
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(named: "outline_search_black_36pt"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        $0.tintColor = .black
    }
    
    private let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "outline_notifications_black_36pt"), for: .normal)
        $0.addTarget(self, action: #selector(handleNotifications), for: .touchUpInside)
        $0.tintColor = .black
    }
    
    private var addGoalButton = UIButton().then {
        $0.setImage(UIImage(systemName: "folder.badge.plus"), for: .normal)
        $0.layer.cornerRadius = 60/2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1.5
        $0.tintColor = .darkGray
        $0.contentMode = .scaleToFill
        $0.isHidden = true
    }
    
    private var addScheduleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        $0.tintColor = .darkGray
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 60/2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    private let floatingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = .black
        $0.tintColor = .white
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 60/2
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.addTarget(self, action: #selector(handleFloatingButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        calendarView.delegate = self
        configureFollowingCollectionView()
        configureSchduleCollectionView()
        view.backgroundColor = .white
        
        view.addSubview(followingCollectionView)
        followingCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(45)
        }
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(followingCollectionView.snp.bottom).offset(10)
            make.height.equalTo(370)
        }
        view.addSubview(scheduleCollectionView)
        scheduleCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-30)
            make.width.height.equalTo(60)
        }
        
        AddButtons.append(addGoalButton)
        AddButtons.append(addScheduleButton)
        
        let buttonStack = UIStackView(arrangedSubviews: [addGoalButton,addScheduleButton])
        
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(floatingButton.snp.top).offset(-10)
            make.centerX.equalTo(floatingButton.snp.centerX)
            make.width.equalTo(60)
            make.height.equalTo(130)
        }
    }
    
    
    //MARK: - configure
    func configureNavigation() {
        let search = UIBarButtonItem(customView: searchButton)
        let notification = UIBarButtonItem(customView: notificationButton)
        navigationItem.rightBarButtonItems = [search,notification]
        
    }
    
    func configureFollowingCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        followingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
        followingCollectionView.backgroundColor = .white
        followingCollectionView.register(FollowingCell.self, forCellWithReuseIdentifier: FollowingCell.reuseIdentifier)
    }
    func configureSchduleCollectionView() {
        scheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.backgroundColor = .white
        scheduleCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    }
    
    //MARK: - selector
    @objc func handleSearch() {
        print("did tap search")
    }
    
    @objc func handleNotifications(){
        print("did tap notification")
    }
    
    @objc func handleFloatingButton() {
        print("DEBUG : Did tap floating Button")
        if isFloating {
            AddButtons.reversed().forEach { button in
                UIView.animate(withDuration: 0.1) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            AddButtons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0
                
                UIView.animate(withDuration: 0.1) {
                     button.alpha = 1
                     self?.view.layoutIfNeeded()
                 }
            }
        }
        isFloating.toggle()
    }
    
}

extension MainController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == followingCollectionView {
            return following.count
        } else {
            return 3
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == followingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as! FollowingCell
            cell.configure(name: following[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
            return cell
        }
        
    }
}

extension MainController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == followingCollectionView {
            return FollowingCell.fittingSize(availableHeight: 35, name: following[indexPath.item])
        } else {
            return CGSize(width: view.frame.width, height: 200)
        }
        
        
    }
}

extension MainController : CalendarViewDelegate {
    func updateCalendarScope(height:CGFloat) {
        calendarView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        self.view.layoutIfNeeded()
    }
    
    
}
