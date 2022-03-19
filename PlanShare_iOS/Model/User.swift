//
//  User.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation

struct User : Codable {
    let email : String
    var nickname : String
    var categories : [Category]?
    var following: [User]?
}
