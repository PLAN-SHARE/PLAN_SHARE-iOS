//
//  ScheduleService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/10.
//

import Foundation
import RxSwift

protocol CategoryServiceProtocol {
    func fetchCategory() -> Observable<[Category]>
    func fetchSchedule(categoryID : Int) -> Observable<[Schedule]>
}
class CategoryService : CategoryServiceProtocol{
    
    // 유저 ID 받아서 해당 카테고리 조회
    func fetchCategory() -> Observable<[Category]> {
        return Observable.create { observer in
            observer.onNext([
                Category(id: 0, title: "프로젝트", iconURL: nil, textColor: "black", scope: .full,
                         schdules: [Schedule(categoryID: 0,startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                                    Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                                    Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true)]
                        ),
                Category(id: 0, title: "프로젝트", iconURL: nil, textColor: "black", scope: .full,
                         schdules: [Schedule(categoryID: 0,startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                                    Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                                    Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true)]
                        )
                
            ])
            return Disposables.create()
        }
    }
    
    func fetchSchedule(categoryID: Int) -> Observable<[Schedule]> {
        return Observable.create { observer in
            observer.onNext([Schedule(categoryID: 0,startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                             Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true),
                             Schedule(categoryID: 0, startTime: "1234", endTime: "3456", text: "프로젝트", isAlarm: false, currentUser: true)])
            
            return Disposables.create()
        }
    }
    
}
