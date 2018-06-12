//
//  deliveryHours.swift
//  Template
//
//  Created by Ingic on 9/12/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  deliveryHours: Object {
    
    dynamic var Id = -1
    dynamic var Friday_From: String!
    dynamic var Friday_To: String!
    dynamic var Monday_From: String!
    dynamic var Monday_To: String!
    dynamic var Saturday_From: String!
    dynamic var Saturday_To: String!
    dynamic var Sunday_From: String!
    dynamic var Sunday_To: String!
    dynamic var Thursday_From: String!
    dynamic var Thursday_To: String!
    dynamic var Tuesday_From: String!
    dynamic var Tuesday_To: String!
    dynamic var Wednesday_From: String!
    dynamic var Wednesday_To: String!
    dynamic var Store_Id = -1
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}
