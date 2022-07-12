//
//  CalendarView.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa

enum DateType: Int,CaseIterable {
    case calendar = 0
    case api
    case full
}
protocol CalendarViewDelegate: class {
    func updateCalendarScope()
}

final class CalendarView: UICollectionReusableView {

    //MARK: - Properties
    static let reuseIdentifier = "CalendarView"

    weak var delegate: CalendarViewDelegate?
    
    var viewModel: MainViewModel! {
        didSet {
            fetch()
        }
    }
    
    private var disposBag = DisposeBag()
    private var calendar = FSCalendar()
    
    private var dates: [Date]? {
        didSet {
            calendar.reloadData()
        }
    }
    
    private var calendarIsMonth: Bool = true{
        didSet {
            if calendarIsMonth == true {
                calendar.setScope(.month, animated: true)
                convertCalendarScopeButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            } else {
                calendar.setScope(.week, animated: true)
                convertCalendarScopeButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            }
        }
    }
    
    private var dateTitleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .left
        $0.text = ""
    }
    
    private lazy var convertCalendarScopeButton = UIButton().then {
        $0.tintColor = .darkGray
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.addTarget(self, action: #selector(didTapConvertCalendar), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
        configureUI()
        fetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        backgroundColor = .clear
        
        addSubview(dateTitleLabel)
        dateTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
        }
        
        addSubview(convertCalendarScopeButton)
        convertCalendarScopeButton.snp.makeConstraints { make in
            make.left.equalTo(dateTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(dateTitleLabel.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(280)
        }
    }
    
    func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = .white
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.headerHeight = 0
        
        //weak
        calendar.appearance.weekdayFont = .noto(size: 16, family: .Bold)
        calendar.appearance.weekdayTextColor = .black
        
        //title
        calendar.appearance.titleFont = .noto(size: 16, family: .Regular)
        calendar.appearance.titleTodayColor = .darkGray
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .none
        calendar.appearance.titleWeekendColor = .darkGray
        calendar.appearance.selectionColor = .mainColor
        calendar.appearance.titleSelectionColor = .white
        calendar.placeholderType = .none
        calendar.select(Date())
        calendar.layer.cornerRadius = 10
        
        dateTitleLabel.text = Date.converToString(from: calendar.currentPage,type: .calendar)
    }
    
    func fetch() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.datesSubject.subscribe(onNext: {
            self.dates = $0
        }).disposed(by: disposBag)
        
        calendar.reloadData()
    }
    
    @objc func didTapConvertCalendar() {
        calendarIsMonth.toggle()
    }
}

extension CalendarView : FSCalendarDelegate,FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.currentDate.onNext(Date.converToString(from: date, type: .full))
        viewModel.eventDate.onNext(Date.converToString(from: date, type: .full))
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.layoutIfNeeded()
        delegate?.updateCalendarScope()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        
        dateTitleLabel.text = Date.converToString(from: currentDate,type: .calendar)
        calendar.select(currentDate)
        viewModel.currentDate.onNext(Date.converToString(from: currentDate, type: .full))
        viewModel.eventDate.onNext(Date.converToString(from: currentDate, type: .full))
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let dates = dates else { return 0 }
        
        if dates.contains(date) {
            return 1
        } else {
            return 0
        }
    }
}
