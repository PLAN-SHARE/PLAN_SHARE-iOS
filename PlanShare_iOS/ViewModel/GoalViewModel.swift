//
//  GoalViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/24.
//

import Foundation
import RxCocoa
import RxSwift

class GoalViewModel {
    
    private let categoryService: CategoryServiceProtocol
    private let scheduleService: ScheduleService
    
    var disposBag = DisposeBag()
    
    init(categoryService: CategoryServiceProtocol,scheduleService: ScheduleService) {
        self.categoryService = categoryService
        self.scheduleService = scheduleService
    }
    
    func fetchCategory() -> Observable<[Goal]> {
        categoryService.fetchCategory()
            .map { categories in
                var goals = [Goal]()
                
                for category in categories {
                    let schedule = category.schedules ?? []
                    
                    let done = schedule.filter{ sc in
                        sc.checkStatus
                    }.count
                    
                    goals.append(Goal(id: category.id, title: category.title, icon: category.icon, color: category.color, visibility: category.visibility, user: category.user,schedules: schedule, doneSchedule: done))
                }
                
                print(goals)
                return goals
            }
    }
    
    func fetchCatgory() -> Observable<[Category]> {
        categoryService.fetchCategory()
    }
}
