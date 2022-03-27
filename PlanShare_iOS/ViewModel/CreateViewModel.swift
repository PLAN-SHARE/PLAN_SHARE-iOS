//
//  CreateViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/20.
//

import Foundation
import RxSwift

class CreateViewModel {
    
    private var categoryService: CategoryService
    
    init(categoryService:CategoryService){
        self.categoryService = categoryService
    }
    
    func fetchCategories()-> Observable<[Category]> {
        categoryService.fetchCategory()
    }
    
    func fetchIcons() -> Observable<[String]> {
        categoryService.fetchIcon()
    }
    
    func createCategory(color: String, icon:String,name:String,visibility:Bool,completion:@escaping(String)->Void) {
        
        let parameters = [
            "color" : color ,
            "icon" : icon ,
            "name" : name ,
            "visibility" : visibility
        ] as [String:Any]
        
        print(parameters)
        categoryService.createCategory(parameters) {
            completion($0)
        }
    }
}
 
