//
//  UserService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/14.
//

import Foundation
import RxSwift
import Alamofire

protocol UserSerivceProtocol {
    func fetchUser() -> Observable<[Member]>
}

class UserService : UserSerivceProtocol{
    
    func fetchUser() -> Observable<[Member]> {
        
        return Observable.create { observer in

            var memberInfo = [Member(id: 0, email: "doyun@gmail.com", kakaoId: 2, nickName: "doyun")]
            
            self.fetchFollow(option: .following) { error, members in
                if let error = error {
                    observer.onError(error)
                }
                
                if let members = members {
                    members.forEach {
                        memberInfo.append($0)
                    }
                }
                
                memberInfo.append(Member(id: -1, email: "plus", kakaoId: 0, nickName: "+"))
                observer.onNext(memberInfo)
            }
            return Disposables.create()
        }
        
    }
    
    func fetchFollow(option:FollowFilterOptions) -> Observable<[Member]> {
        return Observable.create { observer in
            
            self.fetchFollow(option: option) { error, members in
                if let error = error {
                    observer.onError(error)
                }
                
                guard let members = members else {
                    return observer.onNext([])
                }
                
                observer.onNext(members)
            }
            return Disposables.create()
        }
    }
    
    private func fetchFollow(option:FollowFilterOptions, completion:@escaping((Error?,[Member]?) -> Void)) {
        
        let followInfo = option == .following ? "following" : "follow"
        
        let url = "http://52.79.87.87:9090/friend/\(followInfo)/list"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        AF.request(url, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { response in
            switch response.result {
            case .failure(let error) :
                completion(error, nil)
            case .success(let data) :
                do {
                    let decodedJson = try JSONDecoder().decode([Member].self, from: data)
                    completion(nil,decodedJson)
                }
                catch(let error){
                    completion(error,nil)
                }
            }
        })
    }
    
}
