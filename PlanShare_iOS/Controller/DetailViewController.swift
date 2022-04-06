//
//  DetailViewController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/24.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator
import PanModal

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    private var tableView: UITableView!
    
    private var disposBag = DisposeBag()
    
    private var scheduleSubject = BehaviorRelay<[Schedule]>(value: [])
    
    private var category : Category
    
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        configureUI()
    }
    
    init(category:Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindTableView() {
        scheduleSubject.accept(self.category.schedules!)
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposBag)
        scheduleSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: DetailCell.reuseIdentifier, cellType: DetailCell.self)) { index,element,cell in
            cell.schedule = element
        }.disposed(by: disposBag)
        
    }
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = category.title
        
        let ul = UIView().then{
            $0.backgroundColor = .lightGray

        }
        
        view.addSubview(ul)
        ul.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(ul.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    func configure() {
        let viewModel = CategoryViewModel(category: category)
        
        titleLabel.textColor = .init(named: viewModel.textColor)
        titleLabel.text = viewModel.title
    }
    
}

//MARK: - PanModel

extension DetailViewController : PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(10)
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
