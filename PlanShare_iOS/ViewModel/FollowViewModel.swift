//
//  FollowViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.
//

import Foundation
import RxSwift

class FollowViewModel {
    
    private var userService: UserService
    
    init(userService:UserService){
        self.userService = userService
    }
    
    func fetchFollow(option:FollowFilterOptions) -> Observable<[FollowSectionModel]> {
        userService.fetchFollow(option: option)
            .map {
                print($0)
                print([FollowSectionModel(items: $0)])
                return [FollowSectionModel(items: $0)]
            }
    }
    
    
}

