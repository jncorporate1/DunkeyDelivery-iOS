//
//  SearchProduct.swift
//  Template
//
//  Created by Muhammad Zaheer on 18/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class SearchProduct: Object {

    dynamic var Id: Int = -1
    dynamic var Name: String! = ""
    dynamic var Price: Double = 0
    dynamic var Description: String! = ""
    dynamic var Image: String! = ""
    dynamic var Category_Id: Int = -1
    dynamic var Store_Id: Int = -1
    dynamic var TotalRecords: Int = -1
            var Size = RealmOptional<Int>()
}

