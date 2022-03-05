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
    
    var hashValue: Int {
        return title.hashValue &* 16777619
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.title == rhs.title
    }
    
    var title : String
    var icon : UIImage?
    var textColor : UIColor? = .black
    var schedules: [Schedule]?
    var scope : scope
}
