//
//  UserService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/14.
//

import Foundation
import RxSwift

protocol UserSerivceProtocol {
    func fetchUser() -> Observable<[Member]>
}

class UserService : UserSerivceProtocol{
    
    func fetchUser() -> Observable<[Member]> {
        
        return Observable.create { observer in

            observer.onNext([
                Member(id: 0, email: "doyun@gmail.com", kakaoId: 0, nickName: "dino"),
                Member(id: 1, email: "doyun@gmail.com", kakaoId: 2, nickName: "asdf"),
                Member(id: 2, email: "doyun@gmail.com", kakaoId: 3, nickName: "gerg")
            ])

            return Disposables.create()
        }
        
    }
}
