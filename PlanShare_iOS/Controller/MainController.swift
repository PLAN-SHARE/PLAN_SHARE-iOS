//
//  ViewController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/20.
//

import UIKit
import FSCalendar
import KakaoSDKUser

enum Item: Hashable {
    case Following(String)
    case Schdule(Schedule)
    
    
    var hashValue: Int {
        switch self {
        case .Following(let value) :
            return value.hashValue
        case .Schdule(let value) :
            return value.hashValue
        }
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class MainController: UIViewController {
    
    //MARK: - Properties
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Int,Item>!
    
    private var calendarIsMonth : Bool = true {
        didSet {
            collectionView.collectionViewLayout = generateLayout(state: self.calendarIsMonth)
        }
        
    }
    private var categories : [Category] = [Category(title: "프로젝트", icon: nil, textColor: .black,
                                                    schedules: [
                                                        Schedule(startTime: "2022년 1월 10일", endTime: "2022년 1월 11일", text: "과제", isAlarm: false)
                                                    ],scope: .full),
                                           Category(title: "과제", icon: nil, textColor: .black,
                                                    schedules: [
                                                        Schedule(startTime: "2022년 1월 11일", endTime: "2022년 1월 12일", text: "프로젝트", isAlarm: false)
                                                    ],scope: .full),
                                           Category(title: "학교", icon: nil, textColor: .black,
                                                    schedules: [
                                                        Schedule(startTime: "2022년 1월 13일", endTime: "2022년 1월 14일", text: "학교", isAlarm: false)
                                                    ],scope: .full)
    ]
    
    var following = ["박도윤","창묵","호성","희중","가나","다라","하하하","+"]
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
        $0.layer.cornerRadius = 50/2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1.5
        $0.tintColor = .darkGray
        $0.contentMode = .scaleToFill
        $0.isHidden = true
        $0.addTarget(self, action: #selector(addGoal), for: .touchUpInside)
    }
    
    private var addScheduleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        $0.tintColor = .darkGray
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 50/2
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 1.5
        $0.backgroundColor = .white
        $0.isHidden = true
        $0.addTarget(self, action: #selector(addSchedule), for: .touchUpInside)
    }
    
    private let floatingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = .black
        $0.tintColor = .white
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 50/2
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
        print("DEBUG : main view loaded")
        configureCollectionView()
        configureDataSource()
        
        configureUI()
    }
    
    
    //MARK: - configure
    
    func configureUI(){
        configureNavigation()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
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
            make.width.equalTo(50)
            make.height.equalTo(110)
        }
    }
    
    func configureNavigation() {
        let search = UIBarButtonItem(customView: searchButton)
        let notification = UIBarButtonItem(customView: notificationButton)
        navigationItem.rightBarButtonItems = [search,notification]
    }
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout(state:calendarIsMonth))
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        collectionView.backgroundColor = .white
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: CategoryHeader.reuseIdentifier , withReuseIdentifier: CategoryHeader.reuseIdentifier)
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseIdentifier)
        collectionView.register(FollowingCell.self, forCellWithReuseIdentifier: FollowingCell.reuseIdentifier)
        collectionView.register(CalendarView.self, forSupplementaryViewOfKind: CalendarView.reuseIdentifier , withReuseIdentifier: CalendarView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func generateLayout(state:Bool) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return sectionIndex == 0 ? self?.generateFollowingLayout(isMonth: state) : self?.generateCategoryLayout()
        }
        return layout
    }
    
    func generateFollowingLayout(isMonth:Bool) -> NSCollectionLayoutSection {
        
        let estimatedWidth: CGFloat = 55
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = .init(leading: .fixed(5), top: nil, trailing: .fixed(5), bottom: nil)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .absolute(40))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        
        let footerHeight = isMonth ? NSCollectionLayoutDimension.absolute(345) : NSCollectionLayoutDimension.absolute(130)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: footerHeight)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: footerSize, elementKind: CalendarView.reuseIdentifier, alignment: .bottom)]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func generateCategoryLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: CategoryHeader.reuseIdentifier, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Int, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            let section = indexPath.section
            
            if section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as? FollowingCell else {
                    return UICollectionViewCell()
                }
                let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: 35)
                cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
                cell.configure(name: self.following[indexPath.row])
                cell.sizeToFit()
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else {
                    return UICollectionViewCell()
                }
                print(item)
                
                switch item {
                case .Schdule(let schedule) :
                    cell.title = schedule.text
                    break
                    
                case .Following(let name):
                    print("ERror : \(name)")
                    break
                }
                //                cell.title = item[indexPath.row].text
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            switch kind {
            case CalendarView.reuseIdentifier :
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CalendarView.reuseIdentifier,
                    for: indexPath) as? CalendarView else { fatalError("Cannot create footer view") }
                
                supplementaryView.delegate = self
                return supplementaryView
            case  CategoryHeader.reuseIdentifier :
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CategoryHeader.reuseIdentifier,
                    for: indexPath) as? CategoryHeader else { fatalError("Cannot create Header view") }
                
                supplementaryView.category = self.categories[indexPath.row]
                return supplementaryView
                
            default : fatalError("Cannot create supplementary view")
            }
            
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Int, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        
        let followingList = following.map { Item.Following($0) }
        snapshot.appendItems(followingList, toSection: 0)
        
        var cnt = 1
        
        for category in categories {
            snapshot.appendSections([cnt])
            let schdules = (category.schedules ?? []).map { Item.Schdule($0) }
            snapshot.appendItems(schdules, toSection: cnt)
            
            
            cnt += 1
        }
        return snapshot
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
    
    @objc func addGoal(){
        AddButtons.reversed().forEach { button in
            UIView.animate(withDuration: 0.1) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        let vc = SetCategoryController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addSchedule(){
        AddButtons.reversed().forEach { button in
            UIView.animate(withDuration: 0.1) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        let vc = SetScheduleController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainController : UICollectionViewDelegate {
//    collectionView
}

extension MainController : CalendarViewDelegate {

    func updateCalendarScope() {
        calendarIsMonth.toggle()
    }
    
}
