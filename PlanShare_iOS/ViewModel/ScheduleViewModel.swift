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
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyy-MM-dd"

        return df.string(from: schedule.startTime)
    }
//
    var scheduleTitle : NSAttributedString {
        return schedule.isDone ? schedule.text.strikeThrough() : NSAttributedString(string: schedule.text)
    }
    

    init(schedule: Schedule){
        self.schedule = schedule
    }
}
