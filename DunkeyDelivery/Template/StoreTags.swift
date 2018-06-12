//
//  StoreTags.swift
//  Template
//
//  Created by Ingic on 9/12/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  StoreTags: Object {
 
    dynamic var Id = -1
    dynamic var Store_Id = -1
    dynamic var Tag:String!
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}
