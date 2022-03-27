

import Foundation

struct ScheduleResponse: Hashable,Codable {
    let categoryID : Int
    let schedules:[Schedule]?
}

struct Schedule : Hashable,Codable {
    
    var startTime : Date
    var endTime : Date
    var text : String
    var isAlarm : Bool
    var isDone : Bool
}
