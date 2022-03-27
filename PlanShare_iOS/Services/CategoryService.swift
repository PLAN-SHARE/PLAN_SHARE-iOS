//
//  ScheduleService.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/10.
//

import Foundation
import RxSwift
import Alamofire
import SwiftKeychainWrapper

protocol CategoryServiceProtocol {
    func fetchCategory() -> Observable<[Category]>
    //    func fetchSchedule(categoryID : Int) -> Observable<[Schedule]>
}

class CategoryService : CategoryServiceProtocol {
    
    // 유저 ID 받아서 해당 카테고리 조회
    func fetchCategory() -> Observable<[Category]> {
        return Observable.create { observer in
            self.fetchCategory { error, categories in
                if let error = error {
                    observer.onError(error)
                }
                
                guard let categories = categories else {
                    observer.onNext([])
                    return
                }
                
                var categoriesArray = [Category]()
                
                for category in categories {
                    
//                    self.fetchSchedule(categoryID: category.id) { error, schedules in
//                        if let error = error {
//                            print("DEBUG : \(error.localizedDescription)")
//                        }
//
//                        let category = Category(id: category.id, title: category.title, icon: category.icon, color: category.color, visibility: category.visibility, user: category.user, schedules: schedules)
//
//                        categoriesArray.append(category)
//                    }
                    let category = Category(id: category.id, title: category.name, icon: category.icon, color: category.color, visibility: category.visibility, user: category.member, schedules: [Schedule(startTime: Date(), endTime: Date(), text: "일하기", isAlarm: true, isDone: true),Schedule(startTime: Date(), endTime: Date(), text: "일하기", isAlarm: true, isDone: true),Schedule(startTime: Date(), endTime: Date(), text: "일하기", isAlarm: true, isDone: true)
                                                                                                                                                                                                  ])
                    //
                    categoriesArray.append(category)
                }
                
                observer.onNext(categoriesArray)
            }
            return Disposables.create()
        }
    }
    
    func createCategory(_ parameters:[String:Any],completion:@escaping(String)-> Void){
        
        let URL = "http://52.79.87.87:9090/goal/create"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        AF.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let result) :
                print(result)
            case .failure(let error) :
                print("Error : \(error.localizedDescription)")
            }
            print(response)
            
            completion("result")
        }
    }
    
    func fetchIcon() -> Observable<[String]> {
        return Observable.create { observer in
            observer.onNext([
                "alarm","article","bed","business_center","coffee","contact_mail","delete","desktop","edit","event","favorite","fitness_center","house","leaderboard","airport","shipping","notifications","pool","question","room","schedule","search","shopping","shopping_cart","star_rate","tips_and_updates","warning","watch"])
            return Disposables.create()
        }
    }
    
    func fetchFollowing() {
        
    }
    
    func fetchCategory(completion:@escaping((Error?,[CategoryModel]?) -> Void )) {
        
        let URL = "http://52.79.87.87:9090/goal/read/myself"
        
        let accessToken = KeychainWrapper.standard.string(forKey: "AccessToken")
        
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken!)"
         ]

//        AF.request(URL,encoding: JSONEncoding.default,headers: header).responseDecodable(of: [CategoryModel].self) { response in
//            print(response)
//            print("DEBUG : \(response.result)")
//            switch response.result {
//
//            case .failure(let error) :
//                completion(error,nil)
//            case .success(let result):
//                print(result)
////                print(result.categories)
//            }
//        }
        AF.request(URL,method: .get,encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { data in
            switch data.result {
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let data) :
                do {
                    let decodedJson = try JSONDecoder().decode([CategoryModel].self, from: data)
                    completion(nil,decodedJson)
                }
                catch(let error){
                    completion(error,nil)
                }
            }
        })
    }
    
    
    func fetchSchedule(categoryID: Int,completion:@escaping((Error?,[Schedule]?) -> Void)){
        let URL = "http://52.79.87.87:9090/plan/read/myself"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        AF.request(URL, encoding: JSONEncoding.default, headers: header).validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .failure(let error) :
                    print("DEBUG : \(error.localizedDescription)")
                case .success(let result):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                        
                        let decodedJson = try JSONDecoder().decode(ScheduleResponse.self, from: jsonData)
                        completion(nil,decodedJson.schedules)
                    }
                    catch(let error){
                        completion(error,nil)
                    }
                }
            }
    }
}
