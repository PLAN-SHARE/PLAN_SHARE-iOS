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
import PanModal

class MainController: UIViewController {
    
    //MARK: - Properties
    private var collectionView : UICollectionView!
    private var sectionSubject = BehaviorRelay<[SectionModel]>(value: [])
    private let disposBag = DisposeBag()
    let viewModel : MainViewModel!
    
    private var calendarIsMonth : Bool = true {
        didSet {
            collectionView.collectionViewLayout = generateLayout(state: self.calendarIsMonth)
        }
    }
    
    private var isFloating : Bool = false
    
    private lazy var AddButtons = [UIButton]()
    
    private lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        $0.tintColor = .black
    }
    
    private lazy var addGoalButton = UIButton().then {
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
    
    private lazy var addScheduleButton = UIButton().then {
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
    
    private lazy var floatingButton = UIButton().then {
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("dismissCreateView"),
            object: nil
        )
        
        configureCollectionView()
        configureUI()
        bind()
        
        fetchSectionModel()
        
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        view.backgroundColor = .init(named: "edebf5")
        
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
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout(state:calendarIsMonth))
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: CategoryHeader.reuseIdentifier, withReuseIdentifier: CategoryHeader.reuseIdentifier)
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseIdentifier)
        collectionView.register(FollowingCell.self, forCellWithReuseIdentifier: FollowingCell.reuseIdentifier)
        collectionView.register(CalendarView.self, forSupplementaryViewOfKind: CalendarView.reuseIdentifier , withReuseIdentifier: CalendarView.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    // API
    func bind(){
        let dataSource =  dataSource()
        
        sectionSubject.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposBag)
        
        collectionView.rx.itemSelected.subscribe {
            
            guard let element = $0.element else {
                return
            }
            
            let datasource = self.sectionSubject.value[element.section].items[element.row]
            
            switch datasource {
            case .schedule(schedule: let schedule) :
                break
            case .following(member: let user):
                if user.nickName == "+" {
                    let vc = FollowController(viewModel: FollowViewModel(userService: UserService()))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            }
        }.disposed(by: disposBag)
    }
    
    func fetchSectionModel(){
        viewModel.fetchUser()
            .subscribe ( onNext : {
                self.sectionSubject.accept([$0])
            }).disposed(by: disposBag)
        viewModel.fetchCategory()
            .subscribe(onNext : {
                self.sectionSubject.accept(self.sectionSubject.value + $0)
            }).disposed(by: disposBag)
    }
    
    //MARK: - selector
    @objc func handleSearch() {
        let vc = SearchController(viewModel: SearchViewModel(userService: UserService(), categoryService: CategoryService()))
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func handleFloatingButton() {
        if isFloating {
            AddButtons.reversed().forEach { button in
                UIView.animate(withDuration: 0.2) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            AddButtons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0
                
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        }
        isFloating.toggle()
    }
    
    @objc func addGoal(){
        AddButtons.reversed().forEach { button in
            UIView.animate(withDuration: 0.2) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        let vc = CreateCategoryController(viewModel: CreateViewModel(categoryService: CategoryService()))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addSchedule(){
        AddButtons.reversed().forEach { button in
            UIView.animate(withDuration: 0.2) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        let vc = CreateScheduleController(viewModel: CreateViewModel(categoryService: CategoryService()))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        fetchSectionModel()
    }
}

//MARK: - CollectionViewDataSoruce
extension MainController {
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel> {
            dataSource, collectionView, indexPath, item in
            
            switch item {
            case .following(member: let member) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowingCell.reuseIdentifier, for: indexPath) as? FollowingCell else {
                    return UICollectionViewCell()
                }
                cell.member = member
                return cell
            case .schedule(schedule: let schedule) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else {
                    return UICollectionViewCell()
                }
                cell.schedule = schedule
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
            case .ScheduleModel(header: let header, items:_) :
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CategoryHeader.reuseIdentifier,
                    for: indexPath) as? CategoryHeader else { fatalError("Cannot create Header view") }
                supplementaryView.category = header
                supplementaryView.delegate = self
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 20, bottom: 3, trailing: 20)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: CategoryHeader.reuseIdentifier, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

extension MainController : CalendarViewDelegate {
    func updateCalendarScope() {
        calendarIsMonth.toggle()
    }
}

extension MainController : CategoryHeaderDelegate {
    func handleCategory(category: Category) {
        let vc = DetailViewController(category: category)
        self.presentPanModal(vc)
    }
}
