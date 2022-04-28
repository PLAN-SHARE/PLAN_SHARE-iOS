

import Foundation

struct Schedule: Codable {
    var categoryID : Int
    var checkStatus: Bool
    var date : String
    var id : Int
    var name: String
}

struct ScheduleModel : Hashable,Codable {
    static func == (lhs: ScheduleModel, rhs: ScheduleModel) -> Bool {
        return lhs.id == rhs.id
    }
    var checkStatus: Bool
    var date : String
    var goal : CategoryModel
    var id : Int
    var name: String
}
