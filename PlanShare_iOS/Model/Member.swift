//
//  User.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/04.
//

import Foundation

struct MemberResponse: Codable {
    let member : Member
    let status : Bool
}

struct Member: Hashable,Codable {
    let id : Int
    let email : String
    let kakaoId : Int
    let nickName : String
    
    init(id:Int,email:String,kakaoId:Int,nickName:String){
        self.id = id
        self.email = email
        self.kakaoId = kakaoId
        self.nickName = nickName
    }
}
