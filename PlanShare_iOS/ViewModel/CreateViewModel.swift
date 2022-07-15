//
//  CreateViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/20.
//

import Foundation
import RxSwift

class CreateViewModel {
    
    private var categoryService: CategoryService
    private var scheduleService: ScheduleService
    
    var goalSubject = BehaviorSubject<[CategoryModel]>(value: [])
    var disposeBag = DisposeBag()
    
    var selectedCateogry: CategoryModel?
    var dateString: Date?
    
    init(categoryService:CategoryService,
         scheduleService: ScheduleService){
        self.categoryService = categoryService
        self.scheduleService = scheduleService
        
        bind()
    }
    
    func bind(){
        fetchCategoryModels().subscribe(onNext: { [weak self] goal in
            self?.goalSubject.onNext(goal)
        }).disposed(by: disposeBag)
    }
    
    func fetchIcon() -> Observable<[String]> {
        return Observable.create { observer in
            observer.onNext([
                "alarm","article","bed","business_center","coffee","contact_mail","delete","desktop","edit","event","favorite","fitness_center","house","leaderboard","airport","shipping","notifications","pool","question","room","schedule","search","shopping","shopping_cart","star_rate","tips_and_updates","warning","watch"])
            return Disposables.create()
        }
    }
    
    func fetchCategoryModels() -> Observable<[CategoryModel]> {
        categoryService.fetchCategoryModel()
    }
    
    func createCategory(color: String, icon:String,name:String,visibility:Bool,completion:@escaping(String)->Void) {
        
        let parameters = [
            "color" : color ,
            "icon" : icon ,
            "name" : name ,
            "visibility" : visibility
        ] as [String:Any]
        
        categoryService.createCategory(parameters) {
            completion($0)
        }
    }
    
    func createSchedule(goalId: Int64, date:Date,name:String) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.Z"
        
        let dateString = dateFormat.string(from: date).filter {
            $0 != "+"
        }
        let parameters = [
            "name" : name,
            "date" : dateString
        ] as [String:Any]
        
        scheduleService.createSchedule(goalId: goalId, parameters) { result in
            print(result)
        }
    }
}
 
