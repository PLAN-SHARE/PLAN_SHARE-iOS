//
//  User.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation

struct Member : Hashable,Codable {
    let id : Int
    let email : String
    let kakaoId : Int
    let nickName : String
}
