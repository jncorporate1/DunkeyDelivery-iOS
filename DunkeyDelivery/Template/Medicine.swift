//
//  Medicine.swift
//  Template
//
//  Created by Ingic on 9/19/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  Medicine: Object {

    dynamic var Id = -1
    dynamic var Name: String!
    dynamic var Size: String!
    dynamic var Store_Id = -1
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}
