

import Foundation

struct Schedule: Codable {
    var categoryID : Int
    var checkStatus: Bool
    var date : String
    var id : Int
    var name: String
}

struct ScheduleModel: Hashable,Codable {
    static func == (lhs: ScheduleModel, rhs: ScheduleModel) -> Bool {
        return lhs.id == rhs.id
    }
    var checkStatus: Bool
    var date : String
    var goal : CategoryModel
    var id : Int
    var name: String
}

struct ScheduleByDates: Codable{
    let date: String
    let ScheduleLists: [ScheduleList]

    enum CodingKeys: String, CodingKey {
        case date
        case ScheduleLists = "plan_ex_list"
    }
}

struct ScheduleList: Codable {
    let checkStatus: Bool
    let goal: GoalWithoutSchedule
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case checkStatus = "check_status"
        case goal, id, name
    }
}
