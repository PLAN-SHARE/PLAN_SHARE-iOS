//
//  Category.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation
import UIKit

enum scope : Codable {
    case privacy
    case full
}

struct Category : Hashable, Codable {
    var id : Int
    var title : String
    var iconURL: String?
    var textColor : String
    var scope : scope
    var schdules:[Schedule]?
}

struct Schedule : Hashable,Codable {
    var categoryID : Int
    var startTime : String
    var endTime : String
    var text : String
    var isAlarm : Bool
    var currentUser: Bool
}
