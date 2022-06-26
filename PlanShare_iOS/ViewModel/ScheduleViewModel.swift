//
//  ScheduleViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/26.
//

import Foundation

class ScheduleViewModel {
    
    private let schedule: Schedule
    
    private var dateLabel : String {
        return schedule.date
    }

    var scheduleTitle : NSAttributedString {
        return schedule.checkStatus ? schedule.name.strikeThrough() : NSAttributedString(string: schedule.name)
    }

    init(schedule: Schedule){
        self.schedule = schedule
    }
}
