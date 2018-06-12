//
//  CategoryDetail.swift
//  Template
//
//  Created by Ingic on 9/16/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  CategoryDetail: Object {

    dynamic var Id = -1
    dynamic var Name: String!
    dynamic var Status: NSNumber = 0.0
    dynamic var Store_Id = -1
    dynamic var parentId: String!
    dynamic var parentName: String!
            var SubCategories = List<CategoryDetail>()

    override static func primaryKey() -> String? {
        return "Id"
    }
}
