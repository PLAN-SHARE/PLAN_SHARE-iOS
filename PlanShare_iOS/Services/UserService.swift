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
    func fetchFollowingMember(option:FollowFilterOptions, completion:@escaping((Error?,[Member]?) -> Void))
}

class UserService : UserSerivceProtocol{
    
//mainViewModel
    func fetchUser() -> Observable<[Member]> {
        
        return Observable.create { observer in
    
            var memberInfo = [Member(id: 0, email: "doyun@gmail.com", kakaoId: 2, nickName: "doyun")]
            
            self.fetchFollowingMember(option: .following) { error, members in
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
    
//following/Follower 멤버들 조회
    func fetchFollow(option:FollowFilterOptions) -> Observable<[Member]> {
        return Observable.create { observer in
            
            self.fetchFollowingMember(option: option) { error, members in
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
    
//Following,Follower 조회 api
    func fetchFollowingMember(option:FollowFilterOptions, completion:@escaping((Error?,[Member]?) -> Void)) {
        
        let followInfo = option == .following ? "following" : "follower"
        
        let url = "http://3.36.130.116:9090/friend/\(followInfo)/list"
        
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
    
    func searchUser(email:String) -> Observable<MemberResponse?> {
        return Observable.create { observer in
            self.searchUser(email: email){ error,member in
                if let error = error {
                    observer.onError(error)
                }
                
                observer.onNext(member)
            }
            return Disposables.create()
        }
    }
    
    
    private func searchUser(email:String,completion:@escaping((Error?,MemberResponse?) -> Void)){
        
        let url = "http://3.36.130.116:9090/friend/search"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        let parameter = [
            "email" : email
        ]

        AF.request(url, parameters: parameter,encoding: URLEncoding.default,headers: header)
            .responseData(completionHandler: { response in
            switch response.result {
            case .failure(let error) :
                completion(error, nil)
            case .success(let data) :
                do {
                    let decodedJson = try JSONDecoder().decode(MemberResponse.self, from: data)
                    completion(nil,decodedJson)
                }
                catch(let error){
                    completion(error,nil)
                }
            }
        })
        
    }
    
    // follow/unfollow
    func followUnFollow(email:String,request follow:Bool) -> Observable<MemberResponse?> {
        return Observable.create { observer in
            if follow {
                self.follow(email: email){ member,error in
                    if let error = error {
                        observer.onError(error)
                    }
                    
                    observer.onNext(member)
                }
            } else {
                self.unFollow(email: email) { member, error in
                    if let error = error {
                        observer.onError(error)
                    }
                    
                    observer.onNext(member)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func follow(email:String,completion:@escaping(MemberResponse?,Error?)->Void) {
        
        let url = "http://3.36.130.116:9090/friend/follow"
        
        let header = AuthService.shared.getAuthorizationHeader()
//        header?.add(name: "Content-Type", value: "application/json")
        
        let parameter = [
            "toMemberEmail" : email
        ]
        
        AF.request(url,method: .post,parameters: parameter,encoding: URLEncoding.default,headers: header)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { response in
            switch response.result {
            case .failure(let error) :
                completion(nil,error)
            case .success(let data) :
                do {
                    let decodedJson = try JSONDecoder().decode(MemberResponse.self, from: data)
                    print(decodedJson)
                    completion(decodedJson,nil)
                }
                catch(let error){
                    completion(nil,error)
                }
            }
        })
    }
    

    func unFollow(email:String,completion:@escaping(MemberResponse?,Error?)->Void) {
        let url = "http://3.36.130.116:9090/friend/unfollow"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        let parameter = [
            "toMemberEmail" : email
        ]
        
        AF.request(url,method: .post,parameters: parameter,headers: header)
            .responseData(completionHandler: { response in
            switch response.result {
            case .failure(let error) :
                completion(nil,error)
            case .success(let data) :
                do {
                    let decodedJson = try JSONDecoder().decode(MemberResponse.self, from: data)
                    completion(decodedJson,nil)
                }
                catch(let error){
                    completion(nil,error)
                }
            }
        })
    }
}
