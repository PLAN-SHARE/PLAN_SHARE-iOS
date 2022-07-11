
import Foundation
import RxSwift
import Differentiator
import RxCocoa

class MainViewModel {
    
    private let categoryService: CategoryServiceProtocol
    private let userService: UserSerivceProtocol
    private let scheduleService: ScheduleService
    
    private var disposeBag = DisposeBag()
    
    var selectedDate = Date.converToString(from: Date(), type: .full)
//    input
    var currentDate = BehaviorSubject<String>(value: Date.converToString(from: Date(), type: .full))
    var eventDate = BehaviorSubject<String>(value: Date.converToString(from: Date(), type: .full))
    
//    output
    var sectionSubject = PublishSubject<[SectionModel]>()
    var scheduleSubject = PublishSubject<[SectionModel]>()
    var userSubject = PublishSubject<[SectionModel]>()
    var datesSubject = BehaviorSubject<[Date]>(value:[])
    
    
    init(categoryService: CategoryServiceProtocol,
         userService: UserSerivceProtocol,scheduleService: ScheduleService) {
        self.categoryService = categoryService
        self.userService = userService
        self.scheduleService = scheduleService
        
        bind()
    }
    
    func bind() {
        currentDate.subscribe(onNext: { [weak self] date in
            self?.fetchSectionData(current: date)
            self?.selectedDate = date
        }).disposed(by: disposeBag)
        
        eventDate.subscribe(onNext: { [weak self] date in
            self?.fetchDateEvent(date: date)
            self?.selectedDate = date
        }).disposed(by: disposeBag)
    }
    
    func fetchSectionData(current:String = Date.converToString(from: Date(), type: .full)) {
        fetchUser()
            .subscribe(onNext: {
                self.userSubject.onNext([$0])
            }).disposed(by: disposeBag)
        
//        2022년 7월 날짜 조회하여 원하는 날짜로 필터링
        fetchSchedule(date:current)
            .subscribe(onNext: {
                self.scheduleSubject.onNext([$0])
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(userSubject, scheduleSubject).subscribe(onNext: {
            self.sectionSubject.onNext($0.0 + $0.1)
        }).disposed(by: disposeBag)
    }
    
    func fetchDateEvent(date:String = Date.converToString(from: Date(), type: .full)){
        let yyyyMM = date.components(separatedBy: "-").map{ Int($0)! }
        
        self.scheduleService.fetchScheduleByDate(year: yyyyMM[0], month: yyyyMM[1]) { [weak self] scheduleByDates, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            }
            guard let scheduleByDates = scheduleByDates else {
                print("DEBUG: not showing")
                return
            }
            let dates = scheduleByDates.map {
                Date.convertToDate(from: $0.date)
            }
            self?.datesSubject.onNext(dates)
        }
    }
    
    func fetchSchedule(date:String) -> Observable<SectionModel> {
        let yyyyMM = date.components(separatedBy: "-").map{ Int($0)! }
        
        return Observable.create { observer in
            
            self.scheduleService.fetchScheduleByDate(year: yyyyMM[0], month: yyyyMM[1]) { scheduleByDates, error in
                if let error = error {
                    observer.onError(error)
                    print("DEBUG: \(error.localizedDescription)")
                }
                guard let scheduleByDates = scheduleByDates else {
                    print("DEBUG: not showing")
                    return
                }
                
                let schedule = scheduleByDates.filter {
                    return $0.date == date
                }
                
                if schedule.isEmpty {
                    observer.onNext(SectionModel.ScheduleEmptyModel(header: 0, items: []))
                } else {
                    let result = schedule[0]
                    if let scheduleList = result.ScheduleLists {
                        let sectionItem = scheduleList.map {
                            return Schedule(categoryID: $0.id, checkStatus: $0.checkStatus, date: result.date, id: $0.id, name: $0.name)
                        }.map { SectionItem.schedule(schedule: $0)}
                        observer.onNext(SectionModel.ScheduleModel(header: scheduleList.count, items: sectionItem))
                    }
                }
                
            }
            return Disposables.create()
        }
    }
    
    func fetchUser() -> Observable<SectionModel> {
        userService.fetchUser()
            .map {
                let sectionItem = $0.map { SectionItem.following(member: $0)}
                return SectionModel.FollowingModel(items: sectionItem)
            }
    }
    
    func updatePlanCheckStatus(schedule:Schedule?) {
        guard let schedule = schedule else {
            return
        }
        
        scheduleService.updatePlanCheckStatus(goalId: schedule.categoryID, planId: schedule.id)
    }
    
    func deletePlan(schedule:Schedule?) {
        guard let schedule = schedule else {
            return
        }
        
        scheduleService.delegatePlan(goalId: schedule.categoryID, planId: schedule.id)
    }
    
}
//jeong eun jjang do yun j.e ddaggari na neun gong ju ya
