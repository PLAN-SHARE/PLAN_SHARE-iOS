//
//  Category.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation
import UIKit

enum scope {
    case privacy
    case partial
    case full
}

struct Category : Hashable {
    var id : Int
    var title : String
    var iconURL: String?
    var textColor : String
    var scope : scope
}
