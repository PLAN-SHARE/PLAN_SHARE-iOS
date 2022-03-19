//
//  CategoryViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/13.
//

import Foundation
class CategoryViewModel {

    private let category: Category

    var imageUrl : String? {
        return category.iconURL
    }

    var title : String? {
        return category.title
    }

    var textColor : String? {
        return category.textColor
    }

    var categoryScope: scope {
        return category.scope
    }

    init(category: Category) {
        self.category = category
    }
}
