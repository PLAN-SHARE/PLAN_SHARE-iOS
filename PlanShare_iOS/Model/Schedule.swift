//
//  Schedule.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation

struct Schedule : Hashable {
    var categoryID : Int
    var startTime : String
    var endTime : String
    var text : String
    var isAlarm : Bool
}
