//
//  Category.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation
import UIKit

struct CategoryResponse: Codable {
    var categories: [CategoryModel]?
}

struct CategoryModel: Codable,Hashable {
    var color : String
    var icon : String
    var id : Int
    var member: Member
    var name : String
    var visibility : Bool
}

struct Category: Codable {
    var id : Int
    var title : String
    var icon : String
    var color : String
    var visibility : Bool
    var user: Member
    var schedules:[Schedule]?
}
