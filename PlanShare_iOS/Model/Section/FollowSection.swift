//
//  FollowSection.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/28.
//

import Foundation
import Differentiator
import RxDataSources

struct FollowSectionModel {
    var items: [Item]
}

extension FollowSectionModel : SectionModelType {
    
    
    init(original: FollowSectionModel, items: [Member]) {
        self = original
        self.items = items
    }
    typealias Item = Member
    
}
