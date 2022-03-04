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
    func login(request token: String,completion:@escaping(Result<String,Error>)->Void) {
        let URL = "http://52.79.87.87:9090/user/login"
        //        let header : HTTPHeaders = [.authorization(accessToken)]
        let parameters = [
            "token" : token
        ]

        AF.request(URL,method: .get,parameters: parameters,
                   encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseString { response in
            switch response.result {
            case .success(let token) :
                completion(.success(token))
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
    
    
    
}


