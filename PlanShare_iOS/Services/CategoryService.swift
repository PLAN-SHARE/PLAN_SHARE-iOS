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
                
                let group = DispatchGroup()
                
                var categoriesArray = [Category]()
                for category in categories {
                    
                    group.enter()
                    self.fetchSchedule(goalId: category.id) { error, schedules in
                        if let error = error {
                            print("DEBUG : \(error.localizedDescription)")
                        }
                        
                        let category = Category(id: category.id, title: category.name, icon: category.icon, color: category.color, visibility: category.visibility, user: category.member, schedules: schedules)
                        
                        categoriesArray.append(category)
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    observer.onNext(categoriesArray)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchCategoryModel() -> Observable<[CategoryModel]> {
        return Observable.create { observer in
            self.fetchCategory { error, categories in
                if let error = error {
                    observer.onError(error)
                }
                
                guard let categories = categories else {
                    observer.onNext([])
                    return
                }
                observer.onNext(categories)
            }
            return Disposables.create()
        }
    }
    
    func createCategory(_ parameters:[String:Any],completion:@escaping(String)-> Void){
        
        let URL = "http://52.79.87.87:9090/goals"
        
        let header = AuthService.shared.getAuthorizationHeader()
        
        AF.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let result) :
                print(result)
            case .failure(let error) :
                print("Error : \(error.localizedDescription)")
            }
            completion("result")
        }
    }
    
    
    
    func fetchCategory(completion:@escaping((Error?,[CategoryModel]?) -> Void )) {
        let URL = "http://52.79.87.87:9090/goals/my-goals"
        
        let accessToken = KeychainWrapper.standard.string(forKey: "AccessToken")
        
        let header : HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken!)"
        ]
        
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
    
    
    func fetchSchedule(goalId:Int,completion:@escaping(Error?,[Schedule]?)-> Void) {
        let header = AuthService.shared.getAuthorizationHeader()
        
        let URL = "http://52.79.87.87:9090/goals/\(goalId)/plans"
        
        AF.request(URL,headers:header).responseData(completionHandler: { response in
            switch response.result {
                
            case .failure(let error) :
                fatalError(error.localizedDescription)
            case .success(let datas):
                do {
                    let ScheduleModels = try JSONDecoder().decode([ScheduleModel].self, from: datas)
                    
                    var schedule_Array = [Schedule]()
                    for schedule in ScheduleModels {
                        schedule_Array.append(Schedule(categoryID: Int(exactly: goalId)!, checkStatus: schedule.checkStatus, date: schedule.date, id: schedule.id, name: schedule.name))
                    }
                    completion(nil,schedule_Array)
                    
                }
                catch(let error){
                    completion(error,nil)
                }
            }
        })
        
    }
}
