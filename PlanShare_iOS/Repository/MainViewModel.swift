
import Foundation
import RxSwift
import Differentiator

class MainViewModel {
    
    private let categoryService: CategoryServiceProtocol
    private let userService: UserSerivceProtocol
    private let scheduleService: ScheduleService
    
    init(categoryService: CategoryServiceProtocol,
         userService: UserSerivceProtocol,scheduleService: ScheduleService) {
        self.categoryService = categoryService
        self.userService = userService
        self.scheduleService = scheduleService
    }
    
    func fetchCategory() -> Observable<[SectionModel]> {
        categoryService.fetchCategory()
            .map { category in
                category.map { category in
                    if let sheduleItem = category.schedules?.map({
                        SectionItem.schedule(schedule: $0)
                    }) {
                        return SectionModel.ScheduleModel(header: category, items: sheduleItem)
                    } else {
                        return SectionModel.ScheduleModel(header: category, items: [])
                    }
                    
                }
            }
    }
    
    func fetchCatgory() -> Observable<[Category]> {
        categoryService.fetchCategory()
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
