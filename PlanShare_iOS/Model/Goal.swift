//
//  Goal.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/25.
//

import Foundation

struct Goal: Codable {
    var id : Int
    var title : String
    var icon : String
    var color : String
    var visibility : Bool
    var user: Member
    var schedules:[Schedule]?
    var doneSchedule: Int
}
