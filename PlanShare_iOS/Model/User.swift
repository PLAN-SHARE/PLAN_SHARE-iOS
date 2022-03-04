//
//  User.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation

struct User{
    let id : Int
    var categories : [Category]?
    var isCurrentUser : Bool = true
}
