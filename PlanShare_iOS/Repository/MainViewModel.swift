
import Foundation
import RxSwift
import Differentiator

class MainViewModel {
    
    private let categoryService: CategoryServiceProtocol
    private let userService: UserSerivceProtocol
    
    init(categoryService: CategoryServiceProtocol, userService: UserSerivceProtocol) {
        self.categoryService = categoryService
        self.userService = userService
    }
    
//    func fetchCategory() -> Observable<[CategoryViewModel]> {
//        categoryService.fetchCategory()
//            .map { $0.map { CategoryViewModel(category: $0)}}
//    }
//
    func fetchCategory() -> Observable<[SectionModel]> {
        categoryService.fetchCategory()
            .map { category in
                category.map { category in
                    if let sheduleItem = category.schedules?.map({ SectionItem.schedule(schedule: $0)}) {
                        return SectionModel.ScheduleModel(header: category, items: sheduleItem)
                    } else {
                        return SectionModel.ScheduleModel(header: category, items: [])
                    }
                    
                }
            }
    }
    
    func fetchUser() -> Observable<SectionModel> {
        userService.fetchUser()
            .map {
                let sectionItem = $0.map { SectionItem.following(member: $0)}
                return SectionModel.FollowingModel(items: sectionItem)
            }
    }
}
