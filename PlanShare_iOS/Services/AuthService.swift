//
//  AuthService.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/03/01.
//

import Foundation
import KakaoSDKUser
import Alamofire
import SwiftKeychainWrapper

struct AuthService {
    
    static let shared = AuthService()
    
    //Login
    func login(request token: String,completion:@escaping(Result<[String:Any],Error>)->Void) {
        
        let URL = "http://52.79.87.87:9090/user/login"
        
        let parameters = [
            "accessToken" : token
        ]
        
        AF.request(URL,method: .get,parameters: parameters,
                   encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseString { response in
            switch response.result {
                
            case .success(let data) :
                guard let json = try! JSONSerialization.jsonObject(with: Data(data.utf8), options: []) as? [String:Any] else {
                    return
                }
                completion(.success(json))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
        
    }
    
    func logout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                KeychainWrapper.standard.removeObject(forKey: "AccessToken")
                print("logout() success.")
            }
        }
    }
    
    func getAuthorizationHeader(key: String) -> HTTPHeaders? {
        guard let accessToken =  KeychainWrapper.standard.string(forKey: key) else {
            return nil }
        return ["Authorization" : "bearer \(accessToken)"] as HTTPHeaders
    }
    
    func register(nickName:String,completion:@escaping(Result<String,Error>)-> Void) {
        
        guard let email = KeychainWrapper.standard.string(forKey: "email"),
              let id = KeychainWrapper.standard.string(forKey: "ID") else {
                  return
              }
        
        let url = "http://52.79.87.87:9090/user/signup"
        
        //        var request = URLRequest(url: URL(string: url)!, method: .post)
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        let parameters = [
            "email" : email,
            "kakaoId" : Int(id)!,
            "nickName" : nickName
        ] as [String:Any]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate(statusCode: 200..<300).responseString { response in
            switch response.result {
            case .success(let token) :
                completion(.success(token))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
    
    
    //            completionHandler: { response in
    //            print("DEBUG : \(response)")
    //            switch response.result {
    //            case .success(let data) :
    //                guard let data = data else {
    //                    return
    //                }
    //                print(data)
    //                completion(.success("success"))
    //            case .failure(let error) :
    //                completion(.failure(error))
    //            })
    
    
}


