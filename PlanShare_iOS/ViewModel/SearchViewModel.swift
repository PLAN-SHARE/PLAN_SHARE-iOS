//
//  SearchViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchViewModel {
    
    private let userService : UserService!
    private let categoryService : CategoryService!
    
    private let inputText = BehaviorRelay<String>(value: "")
    
    init(userService:UserService,categoryService:CategoryService) {
        self.userService = userService
        self.categoryService = categoryService
    }
    
    func search(text:String) -> Observable<[MemberResponse]> {
//        let isEmail = isValidEmail(testStr: text)
        
        userService.searchUser(email: text).map {
            guard let user = $0 else {
                return []
            }
            
            return [user]
        }
        
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func handleFollow(member:Member,isFollow: Bool) -> Observable<[MemberResponse]> {
        userService.followUnFollow(email: member.email, request: isFollow)
            .map {
                guard let memeberResponse = $0 else {
                    return []
                }
                return [memeberResponse]
            }
    }
}
