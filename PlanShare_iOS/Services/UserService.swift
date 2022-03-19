//
//  UserService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/14.
//

import Foundation
import RxSwift

protocol UserSerivceProtocol {
    func fetchUser() -> Observable<[User]>
}

class UserService : UserSerivceProtocol{
    
    func fetchUser() -> Observable<[User]> {
        
        return Observable.create { observer in

            observer.onNext([
                User(email: "doyun@gmail.com", nickname: "dino", categories: nil, following: nil),
                User(email: "1234", nickname: "12341414"),
                User(email: "Add", nickname: "+")
            ])

            return Disposables.create()
        }
        
    }
}
