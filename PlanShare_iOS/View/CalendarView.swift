//
//  CalendarView.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/21.
//

import UIKit
import FSCalendar

protocol CalendarViewDelegate: class {
    func updateCalendarScope(height:CGFloat)
}
class CalendarView: UIView {

    //MARK: - Properties
    weak var delegate: CalendarViewDelegate?
    
    private var calendar = FSCalendar()
    
    private var calendarIsMonth : Bool = true{
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
    
    private var convertCalendarScopeButton = UIButton().then {
        $0.tintColor = .darkGray
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.addTarget(self, action: #selector(didTapConvertCalendar), for: .touchUpInside)
    }
    
    private var convertViewScheduleModeButton = UIButton().then {
        $0.tintColor = .darkGray
        $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        $0.addTarget(self, action: #selector(didTapConvertScheduleMode), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
        
        backgroundColor = .white
        
        addSubview(dateTitleLabel)
        dateTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        addSubview(convertCalendarScopeButton)
        convertCalendarScopeButton.snp.makeConstraints { make in
            make.left.equalTo(dateTitleLabel.snp.right).offset(10)
            make.centerY.equalTo(dateTitleLabel.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        addSubview(convertViewScheduleModeButton)
        convertViewScheduleModeButton.snp.makeConstraints { make in
            make.centerY.equalTo(convertCalendarScopeButton)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(30)
        }
        
        addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(300)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.headerHeight = 0
        
        //weak
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 16)
        calendar.appearance.weekdayTextColor = .darkGray
        
        //title
        calendar.appearance.titleFont = .systemFont(ofSize: 18)
        calendar.appearance.eventSelectionColor = .green
        
        calendar.appearance.titleTodayColor = .orange
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .none
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.selectionColor = .black
        calendar.appearance.titleSelectionColor = .white
        calendar.placeholderType = .none

        dateTitleLabel.text = converToString(from: calendar.currentPage)
    }
    
    @objc func didTapConvertCalendar() {
        calendarIsMonth.toggle()
    }
    @objc func didTapConvertScheduleMode() {
        
    }
    func converToString(from date: Date) -> String {
        let dfMatter = DateFormatter()
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyy년 MM월"
        
        return dfMatter.string(from: date)
    }
}

extension CalendarView : FSCalendarDelegate,FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(date) 날짜가 선택되었습니다.")
    }
    
    // 날짜 선택 해제 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(date) 날짜가 선택 해제 되었습니다.")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        
        self.layoutIfNeeded()
        delegate?.updateCalendarScope(height: bounds.height + 40)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        dateTitleLabel.text = converToString(from: calendar.currentPage)
    }
    
}
