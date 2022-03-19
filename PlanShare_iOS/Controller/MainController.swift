//
//  ViewController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/20.
//

import UIKit
import FSCalendar
import KakaoSDKUser
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class MainController: UIViewController {
    //MARK: - Properties
    private var collectionView : UICollectionView!
    //    private var dataSource : UICollectionViewDiffableDataSource<Int,Item>!
    
    private var sectionSubject = BehaviorRelay<[SectionModel]>(value: [])
    
    private let disposBag = DisposeBag()
    
    let viewModel : MainViewModel!
    
    private var calendarIsMonth : Bool = true {
        didSet {
            collectionView.collectionViewLayout = generateLayout(state: self.calendarIsMonth)
        }
    }
    
    var following = ["박도윤","창묵","호성","희중","가나","다라","하하하","+"]
    private var isFloating : Bool = false
    
    private lazy var AddButtons = [UIButton]()
    
    private lazy var searchButton = UIButton().then {
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
        configureNavigation()
        configureCollectionView()
        configureUI()
        fetchSectionModel()
        bind()
        //        subscribe()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure
    func configureUI(){
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
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: CategoryHeader.reuseIdentifier, withReuseIdentifier: CategoryHeader.reuseIdentifier)
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseIdentifier)
        collectionView.register(FollowingCell.self, forCellWithReuseIdentifier: FollowingCell.reuseIdentifier)
        collectionView.register(CalendarView.self, forSupplementaryViewOfKind: CalendarView.reuseIdentifier , withReuseIdentifier: CalendarView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    
    // API
    func bind(){
        let dataSource =  dataSource()
        sectionSubject.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath)
            print(self.sectionSubject.value[0].items.count)
//            if indexPath.section == 0 && indexPath.row = sectionSubject.value[0].items.count {
//
//            }
        }).disposed(by: disposBag)
    }
    
    func fetchSectionModel(){
        viewModel.fetchUser().subscribe { sectionModel in
            self.sectionSubject.accept([sectionModel])
        }.disposed(by: disposBag)
        
        viewModel.fetchCategory().subscribe { sectionModel in
            self.sectionSubject.accept(self.sectionSubject.value + sectionModel)
        }.disposed(by: disposBag)
    }
    
    //MARK: - selector
    @objc func handleSearch() {
        print("DEBUG : Handle Search")
        let vc = UINavigationController(rootViewController:SearchController())
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: false)
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

//MARK: - CollectionViewDataSoruce
extension MainController {
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel> {
            dataSource, collectionView, indexPath, item in
            
            switch dataSource.sectionModels[indexPath.section] {
            case .FollowingModel(items: let items) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as? FollowingCell else {
                    return UICollectionViewCell()
                }
                switch items[indexPath.row] {
                case .following(user: let user):
                    cell.configure(name: user.nickname)
                    let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: 35)
                    cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
                    cell.sizeToFit()
                case .schedule(schedule: _): break
                }
                return cell
                
            case .ScheduleModel(header: _, items: let items) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else {
                    return UICollectionViewCell()
                }
                switch items[indexPath.row] {
                case .schedule(schedule: let schdule):
                    cell.schedule = schdule
                default : break
                }
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            switch kind {
            case CalendarView.reuseIdentifier :
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CalendarView.reuseIdentifier,
                    for: indexPath) as? CalendarView else { fatalError("Cannot create footer view") }
                supplementaryView.delegate = self
                return supplementaryView
            case CategoryHeader.reuseIdentifier :
                switch dataSource.sectionModels[indexPath.section] {
                case .FollowingModel(items: _) : break
                case .ScheduleModel(header: let viewModel, items:_) :
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: CategoryHeader.reuseIdentifier,
                        for: indexPath) as? CategoryHeader else { fatalError("Cannot create Header view") }
                    supplementaryView.categoryViewModel = viewModel
                    return supplementaryView
                }
                
            default:
                return UICollectionReusableView()
            }
            return UICollectionReusableView()
        }
    }
    
}
//MARK: - CollectionView Layout
extension MainController {
    func generateLayout(state:Bool) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return sectionIndex == 0 ? self?.generateFollowingLayout(isMonth: state) : self?.generateCategoryLayout()
        }
        return layout
    }
    
    func generateFollowingLayout(isMonth:Bool) -> NSCollectionLayoutSection {
        
        let estimatedWidth: CGFloat = 45
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
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
    //
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
}
extension MainController : UICollectionViewDelegate {
    //    collectionView
}

extension MainController : CalendarViewDelegate {
    func updateCalendarScope() {
        calendarIsMonth.toggle()
    }
}


