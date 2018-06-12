//
//  User.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object {

    dynamic var FirstName:String!
    dynamic var FullName:String!
    dynamic var Email : String!
    dynamic var City : String!
    dynamic var State : String!
    dynamic var Country : String!
    dynamic var Dob : String!
    dynamic var Role = -1
    dynamic var Username : String!
    dynamic var Status = -1
    dynamic var VerificationToken : String!
    dynamic var TotalReviews = -1
    dynamic var TotalOrders = -1
    dynamic var LastName:String!
    dynamic var Token: Token!
    dynamic var Phone: String!
    dynamic var ProfilePictureUrl: String!
    dynamic var Id = -1
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}

class Token: Object {
    
    dynamic var access_token:String!
    dynamic var expires_in:String!
    dynamic var refresh_token:String!
    dynamic var token_type:String!
}


