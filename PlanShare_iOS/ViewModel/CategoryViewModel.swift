//
//  CategoryViewModel.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/13.
//

import Foundation
class CategoryViewModel {

    private let category: Category

    var imageUrl : String {
        return category.icon
    }

    var title : String? {
        return category.title
    }

    var textColor : String {
        return category.color.uppercased()
    }

    var categoryScope: Bool {
        return category.visibility
    }

    init(category: Category) {
        self.category = category
    }
}
