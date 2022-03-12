//
//  ScheduleService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/10.
//

import Foundation
import RxSwift

protocol SchduleServiceProtocol {
    func fetchSchedule() -> Observable<[Schedule]>
}
class SchduleService : SchduleServiceProtocol{
    
//    func fetchNews() -> Observable<[Category]> {
//        return Observable.create { observer in
//
//            observer.onNext([
//                Category(title: "doyun", icon: UIImage(systemName: "xmark"), textColor: .red, schedules:
//                              [Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true)
//                              ], scope: .full),
//                Category(title: "doyun", icon: UIImage(systemName: "xmark"), textColor: .red, schedules:
//                              [Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true)
//                              ], scope: .full),
//                Category(title: "doyun", icon: UIImage(systemName: "xmark"), textColor: .red, schedules:
//                              [Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true)
//                              ], scope: .full),
//                Category(title: "doyun", icon: UIImage(systemName: "xmark"), textColor: .red, schedules:
//                              [Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true),
//                              Schedule(startTime: "22.01.30 10:30", endTime: "22.01.30 10:30", text: "asd", isAlarm: true)
//                              ], scope: .full)
//            ])
//
//            return Disposables.create()
//        }
//    }
//
    func fetchSchedule() -> Observable<[Schedule]> {
        <#code#>
    }
    
}
