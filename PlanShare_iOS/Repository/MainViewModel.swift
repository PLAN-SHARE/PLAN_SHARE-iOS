
import Foundation
import RxSwift
import Differentiator
import RxCocoa

class MainViewModel {
    
    private let categoryService: CategoryServiceProtocol
    private let userService: UserSerivceProtocol
    private let scheduleService: ScheduleService
    
    private var disposBag = DisposeBag()
    
    var sectionSubject = BehaviorSubject<[SectionModel]>(value:[])
    var scheduleSubject = PublishRelay<ScheduleByDates>()
    
    var date = Date().toString()[0..<7]
    
    init(categoryService: CategoryServiceProtocol,
         userService: UserSerivceProtocol,scheduleService: ScheduleService) {
        self.categoryService = categoryService
        self.userService = userService
        self.scheduleService = scheduleService
        
        fetchSchedule(date: Date.converToString(from: Date(), type: .api))
            .take(1)
            .bind(to: scheduleSubject)
//            .subscribe(onNext: { [weak self] schedule in
//                self?.scheduleSubject.accept(schedule)
//            }).disposed(by: disposBag)
        
        fetchSectionData(current: Date.converToString(from: Date(), type: .full))
    }
    
    func fetchSectionData(current:String) {
        if date != current {
            fetchSchedule(date: current)
                .subscribe(onNext: {
                    self.scheduleSubject.accept($0)
                }).disposed(by: disposBag)
            date = current
        }
        
        let user = fetchUser().asObservable()
            .subscribe(onNext:{
                self.sectionSubject.onNext([$0])
        }).disposed(by: disposBag)
//
        let schedule = scheduleSubject
            .filter {
                print($0.date)
                print(current)
                return $0.date == current
                
            }
            .map { schedulebydates -> SectionModel in
                let date = schedulebydates.date
                let sectionItem = schedulebydates.ScheduleLists.map {
                    return Schedule(categoryID: $0.id, checkStatus: $0.checkStatus, date: date, id: $0.id, name: $0.name)
                }.map { SectionItem.schedule(schedule: $0)}
                
                let sectionModel = SectionModel.ScheduleModel(header: schedulebydates.ScheduleLists.count, items: sectionItem)
                return sectionModel
            }
        
        Observable.combineLatest(fetchUser(), schedule).subscribe(onNext: {
            let output = [$0.0,$0.1]
            print(output)
            self.sectionSubject.onNext(output)
        }).disposed(by: disposBag)
     
        
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
    
    func fetchSchedule(date:String) -> Observable<ScheduleByDates> {
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
                scheduleByDates.forEach { scheduleByDates in
                    observer.onNext(scheduleByDates)
                }
                
            }
            return Disposables.create()
        }
        
        
    }
}
